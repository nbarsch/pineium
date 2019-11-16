#' lit_local()
#'
#' Primary selenium browser launcher
#' @param browser chrome or firefox
#' @param port  port number
#' @param headless logical (TRUE or FALSE, no quotes) browse headlessly?
#' @export
lit_local <-function(port=4444,browser="chrome",headless=FALSE, retry_max=2){

  os <- tolower(Sys.info()[["sysname"]])
  noarm <- !grepl("arm",tolower(Sys.info()[["machine"]]))
  if(os!="windows" & !isTRUE(noarm)){
    #install automated chrome driver
    if(!file.exists("/usr/local/bin/chromedriver")){
      system("export a=$(uname -m)")
      system("rm -r /tmp/chromedriver/")
      system("mkdir /tmp/chromedriver/")
      system("wget -O /tmp/chromedriver/LATEST_RELEASE http://chromedriver.storage.googleapis.com/LATEST_RELEASE")
      catvar <- system("cat /tmp/chromedriver/LATEST_RELEASE",intern=T)
      os <- tolower(Sys.info()[["sysname"]])
      if(os!="windows" & os!="linux"){os <-"mac"}
      system(paste0('wget -O /tmp/chromedriver/chromedriver.zip http://chromedriver.storage.googleapis.com/',catvar,'/chromedriver_',os,'64.zip'))
      system("unzip -o /tmp/chromedriver/chromedriver.zip chromedriver -d /usr/local/bin/")
    }
  }
  if(os!="windows"){
    browser <- tolower(browser)
    if(browser=="firefox"){print("WARNING: Firefox is more error prone than chrome on some platforms. If you hit an error, please try browser='chrome'")}
    Sys.sleep(2)
    port <- as.integer(port)
    system(paste0("kill -9 $(lsof -t -i:",port," -sTCP:LISTEN)"))
    system(paste0("kill -9 $(lsof -t -i:",port+1," -sTCP:LISTEN)"))
    system(paste0("kill -9 $(lsof -t -i:",port-1," -sTCP:LISTEN)"))
    Sys.sleep(1)
    try(system("sudo docker stop $(sudo docker ps -a -q)"))
    try(system("docker stop $(docker ps -a -q)"))

    Sys.sleep(1)
    try(system("sudo docker rm $(sudo docker ps -a -q)"))
    try(system("docker rm $(docker ps -a -q)"))
  }

  Sys.sleep(1)
  library(RSelenium)
  library(binman)
  library(wdman)
  library(httr)
  library(devtools)
  oiter <- 0
  odone <-FALSE
  while(odone==FALSE){
    #rD <- rsDriver(port=4444L, browser="chrome",)
    Sys.sleep(1)
    if(browser=="firefox"){
      if(isTRUE(headless)){
        eCaps = list(
          "moz:firefoxOptions" = list(
            args = list('--headless')
          )
        )
        rD <- tryCatch({rsDriver(port=port,browser="firefox", extraCapabilities=eCaps)},error=function(e){print(paste0("WARNING: Firefox is more error prone than chrome on some platforms. If you hit an error, please try browser='chrome' or run firefox standalone or docker"));return("ERROR_LAUNCHING_SELENIUM_LOCAL_HEADLESS")})
        Sys.sleep(2)
      }else{
        rD <- tryCatch(rsDriver(port=port,browser="firefox"),error=function(e){print(paste0("WARNING: Firefox is more error prone than chrome on some platforms. If you hit an error, please try browser='chrome' or run firefox standalone or docker"));return("ERROR_LAUNCHING_SELENIUM_LOCAL_HEADLESS")})
        Sys.sleep(2)
      }
      if(!("list"%in%class(rD))){test_open <-paste0("ERROR_LAUNCHING_SELENIUM_LOCAL headless= ",headless, " browser=FIREFOX")}
      if(is.list(test_open)){
        test_open <-paste0("SELENIUM_LOCAL_LAUNCHED_SUCCESSFULLY : headless= ",headless," browser=FIREFOX")
        remDr <- rD$client
      }else{
        test_open <- paste0("ERROR_LAUNCHING_SELENIUM_LOCAL headless=",headless," browser=FIREFOX")
        print(paste0("WARNING: Firefox is more error prone than chrome on some platforms. If you hit an error, please try browser='chrome' or run firefox standalone or docker"))
        Sys.sleep(2)
      }
    }
    if(browser=="chrome"){
      if(isTRUE(headless)){
        eCaps <- list(chromeOptions = list(
          args = c('--headless', '--disable-gpu', '--window-size=1280,800')
          #extensions=list(base64enc::base64encode("/home/neal/tec_fblikes/alertblock.crx"))
          )
        )
        Sys.sleep(1)
        rD <- chrome(port=4444L, version=unlist(list_versions("chromedriver"))[1])
        Sys.sleep(1)
        #rD <- tryCatch(rsDriver(port=port,browser="chrome", extraCapabilities=eCaps),error=function(e){return("ERROR_LAUNCHING_SELENIUM_LOCAL_HEADLESS")})
        remDr <- remoteDriver(port=4444L,browser="chrome",extraCapabilities=eCaps)
        Sys.sleep(1)
        remDr$open()
        Sys.sleep(2)
      }else{
        #rD <- tryCatch(rsDriver(port=port,browser="chrome"),error=function(e){return("ERROR_LAUNCHING_SELENIUM_LOCAL_HEADLESS")})
        Sys.sleep(1)
        rD <- chrome(port=4444L, version=unlist(list_versions("chromedriver"))[1])
        Sys.sleep(1)
        #rD <- tryCatch(rsDriver(port=port,browser="chrome", extraCapabilities=eCaps),error=function(e){return("ERROR_LAUNCHING_SELENIUM_LOCAL_HEADLESS")})
        remDr <- remoteDriver(port=4444L,browser="chrome")
        Sys.sleep(1)
        remDr$open()
        Sys.sleep(2)
      }
    }

    Sys.sleep(1.5)
    success <- FALSE
    #tryCatch({remDr$navigate("http://www.google.com");Sys.sleep(3);tester<- unlist(remDr$getTitle());Sys.sleep(1);if(tester=="Google"){return("SELENIUM_LAUNCHED_SUCCESSFULLY")}else{return("ERROR_LAUNCHING_SELENIUM")}},error=function(e){return("ERROR_LAUNCHING_SELENIUM")})
    tester <- tryCatch({remDr$navigate("http://www.google.com")},error=function(e){return("ERROR_LAUNCHING_SELENIUM")})
    Sys.sleep(1)
    if(is.null(tester)){tester <- "LOCAL SELENIUM_LAUNCHED_SUCCESSFULLY"}
    if(grepl("SUCCESS",tester)){
      print(paste0("LOCAL SUCCESSFULLY LAUNCHED LOCAL SELENIUM headless=",headless))
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
    print(paste0("LOCAL SUCCESSFUL_SELENIUM_LAUNCH= ",success))
    return(remDr)
  }else{
    return(print("LOCAL FAILED_SELENIUM_LAUNCH"))
    if(browser=="firefox"){print(paste0("WARNING: Firefox is more error prone than chrome on some platforms. If you hit an error, please try browser='chrome' or launch firefox lit_standalone() or lit_docker() functions"))}
  }
}
