#' lit_docker()
#'
#' Primary selenium browser launcher
#' @param browser chrome or firefox
#' @param port  port number
#' @param headless MUST BE =TRUE FOR USING DOCKER
#' @export
lit_docker <-function(port=4444,browser="chrome",headless=TRUE, retry_max=2){
  if(headless==FALSE){
    print("NOTE: WHEN USING DOCKER YOU ARE REQUIRED TO RUN HEADLESS, OVERRIDING AND USING headless=TRUE")
    Sys.sleep(2)
  }

  #install automated chrome driver
  if(!file.exists("/usr/local/bin/chromedriver")){
    system("export a=$(uname -m)")
    system("rm -r /tmp/chromedriver/")
    system("mkdir /tmp/chromedriver/")
    system("wget -O /tmp/chromedriver/LATEST_RELEASE http://chromedriver.storage.googleapis.com/LATEST_RELEASE")
    catvar <- system("cat /tmp/chromedriver/LATEST_RELEASE",intern=T)
    os <- tolower(Sys.info()[["sysname"]])
    system(paste0('wget -O /tmp/chromedriver/chromedriver.zip http://chromedriver.storage.googleapis.com/',catvar,'/chromedriver_',os,'64.zip'))
    system("unzip -o /tmp/chromedriver/chromedriver.zip chromedriver -d /usr/local/bin/")
  }

  library(RSelenium)


  Sys.sleep(1)
  port <- as.integer(port)
  system(paste0("kill -9 $(lsof -t -i:",port," -sTCP:LISTEN)"))
  system(paste0("kill -9 $(lsof -t -i:",port+1," -sTCP:LISTEN)"))
  system(paste0("kill -9 $(lsof -t -i:",port-1," -sTCP:LISTEN)"))
  Sys.sleep(1)
  system("sudo docker stop $(sudo docker ps -a -q)")
  Sys.sleep(1)
  system("sudo docker rm $(sudo docker ps -a -q)")
  Sys.sleep(1)
  system(paste0('sudo docker pull selenium/standalone-',browser))
  Sys.sleep(1)
  system(paste0('sudo docker run -d -p ',port+1,":",port,' selenium/standalone-', browser))
  Sys.sleep(6)
  oiter <- 0
  odone <-FALSE
  while(odone==FALSE){
    #rD <- rsDriver(port=4445L, browser="firefox")
    Sys.sleep(1)
    if(browser=="firefox"){
      if(isTRUE(headless)){
        eCaps = list(
          "moz:firefoxOptions" = list(
            args = list('--headless')
          )
        )
        remDr <- remoteDriver(port=port+1,browserName="firefox", extraCapabilities=eCaps)
        Sys.sleep(10)
        test_open <- tryCatch(remDr$open(),error=function(e){return("ERROR_LAUNCHING_SELENIUM_DOCKER_HEADLESS")})
        Sys.sleep(10)
        if(is.list(test_open)){test_open <-"SELENIUM_DOCKER_LAUNCHED_SUCCESSFULLY : headless= TRUE browser=FIREFOX"}
        Sys.sleep(2)

      }else{
        remDr <- remoteDriver(port=port+1,browserName="firefox")
        Sys.sleep(10)
        test_open <- tryCatch(remDr$open(),error=function(e){return("ERROR_LAUNCHING_SELENIUM_DOCKER_GUI")})
        Sys.sleep(10)
        if(is.list(test_open)){test_open <-"SELENIUM_DOCKER_LAUNCHED_SUCCESSFULLY : headless= FALSE browser= FIREFOX"}
      }
    }

    if(browser=="chrome"){
      if(isTRUE(headless)){
        eCaps <- list(chromeOptions = list(
          args = c('--headless', '--disable-gpu', '--window-size=1280,800')
          #extensions=list(base64enc::base64encode("/home/neal/tec_fblikes/alertblock.crx"))
        )
        )
        remDr <- remoteDriver(port=port+1,browserName="chrome", extraCapabilities=eCaps)
        Sys.sleep(10)
        test_open <- tryCatch(remDr$open(),error=function(e){return("ERROR_LAUNCHING_SELENIUM_DOCKER_HEADLESS")})
        Sys.sleep(10)
        if(is.list(test_open)){test_open <-"SELENIUM_DOCKER_LAUNCHED_SUCCESSFULLY : headless= TRUE browser=CHROME"}
        Sys.sleep(2)

      }else{
        remDr <- remoteDriver(port=as.integer(port+1),browserName="chrome")
        Sys.sleep(10)
        test_open <- tryCatch(remDr$open(),error=function(e){return("ERROR_LAUNCHING_SELENIUM_DOCKER_GUI")})
        Sys.sleep(10)
        if(is.list(test_open)){test_open <-"SELENIUM_DOCKER_LAUNCHED_SUCCESSFULLY : headless= FALSE browser= CHROME"}
      }
    }

    Sys.sleep(1.5)
    success <- FALSE
    #tryCatch({remDr$navigate("http://www.google.com");Sys.sleep(3);tester<- unlist(remDr$getTitle());Sys.sleep(1);if(tester=="Google"){return("SELENIUM_LAUNCHED_SUCCESSFULLY")}else{return("ERROR_LAUNCHING_SELENIUM")}},error=function(e){return("ERROR_LAUNCHING_SELENIUM")})
    tester <- tryCatch({remDr$navigate("http://www.google.com")},error=function(e){return("ERROR_LAUNCHING_SELENIUM")})
    Sys.sleep(1)
    if(is.null(tester)){tester <- "SELENIUM_DOCKER_LAUNCHED_SUCCESSFULLY"}
    if(grepl("SUCCESS",tester)){
      print("SUCCESSFULLY LAUNCHED DOCKER SELENIUM")
      success <- TRUE
      odone <- TRUE
    }else{
      success <- FALSE
      odone <- FALSE
      Sys.sleep(1)
      oiter <- oiter+1
      if(oiter>retry_max){odone <- TRUE}
    }
  }
  if(isTRUE(success)){
    print(paste0("SUCCESSFUL_SELENIUM_DOCKER_LAUNCH= ",success))
    return(remDr)
  }else{
    return(print("FAILED_SELENIUM_DOCKER_LAUNCH"))
  }
}

