#' lit_standalone()
#'
#' Primary selenium browser launcher
#' @param browser chrome or firefox
#' @param port  port number
#' @param headless logical (TRUE or FALSE, no quotes) browse headlessly?
#' @export
lit_standalone <-function(browser="chrome", port=4444,headless=FALSE, retry_max=2){
  port <- as.integer(port)
  system(paste0("sudo kill -9 $(lsof -t -i:",port," -sTCP:LISTEN)"))
  system(paste0("sudo kill -9 $(lsof -t -i:",port+1," -sTCP:LISTEN)"))
  system(paste0("sudo kill -9 $(lsof -t -i:",port-1," -sTCP:LISTEN)"))


  if(browser=="chrome"){
    system("sudo apt-get install chromium-chromedriver -y")
  }


  if(!file.exists("/usr/local/bin/selenium-server-standalone-3.141.59.jar")){
    #system("sudo apt-get install geckodriver")
    if(file.exists("/usr/local/bin/selenium-server-standalone-3.141.59.jar")){system("sudo rm -f /usr/local/bin/selenium-server-standalone-3.141.59.jar")}
    if(file.exists("selenium-server-standalone-3.141.59.jar")){system("sudo rm -f /usr/local/bin/selenium-server-standalone-3.141.59.jar")}
    system("wget https://selenium-release.storage.googleapis.com/3.141/selenium-server-standalone-3.141.59.jar")
    if(file.exists("/usr/local/bin/selenium-server-standalone-3.141.59.jar")){system("sudo rm -f /usr/local/bin/selenium-server-standalone-3.141.59.jar")}
    system("sudo mv -f selenium-server-standalone-3.141.59.jar /usr/local/bin/selenium-server-standalone-3.141.59.jar")
    system("unzip -n /usr/local/bin/selenium-server-standalone-3.141.59.jar")
    #Sys.setenv(Dwebdriver.chrome.driver="/usr/local/bin/selenium-server-standalone-3.141.59.jar")
    #Sys.setenv(Dwebdriver.gecko.driver="/home/neal/node_modules/geckodriver")
    #Sys.setenv(webdriver.gecko.driver="/home/neal/node_modules/geckodriver")
    Sys.sleep(1)
  }

  system("java -jar /usr/local/bin/selenium-server-standalone-3.141.59.jar",wait=FALSE)
  Sys.sleep(5)
  library(RSelenium)
  library(wdman)
  library(binman)
  library(pineium)
  library(devtools)
  library(curl)

  oiter <- 0
  odone <-FALSE
  while(odone==FALSE){
    Sys.sleep(1)
    if(browser=="firefox"){
    if(isTRUE(headless)){
      eCaps = list(
        "moz:firefoxOptions" = list(
          args = list('--headless')
        )
      )
      remDr <- remoteDriver(remoteServerAddr="localhost",port=port,browserName="firefox", extraCapabilities=eCaps)
      Sys.sleep(3)
      test_open <- tryCatch(remDr$open(),error=function(e){return("ERROR_LAUNCHING_SELENIUM_STANDALONE_HEADLESS")})
      if(is.list(test_open)){test_open <-"SELENIUM_STANDALONE_LAUNCHED_SUCCESSFULLY : headless= TRUE browser=FIREFOX"}
      Sys.sleep(2)

    }else{
      remDr <- remoteDriver(remoteServerAddr="localhost",port=port,browserName="firefox")
      Sys.sleep(3)
      test_open <- tryCatch(remDr$open(),error=function(e){return("ERROR_LAUNCHING_SELENIUM_STANDALONE_GUI")})
      if(is.list(test_open)){test_open <-"SELENIUM_STANDALONE_LAUNCHED_SUCCESSFULLY : headless= FALSE browser= FIREFOX"}
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
      remDr <- remoteDriver(remoteServerAddr="localhost",port=port,browserName="chrome", extraCapabilities=eCaps)
      Sys.sleep(3)
      test_open <- tryCatch(remDr$open(),error=function(e){return("ERROR_LAUNCHING_SELENIUM_STANDALONE_HEADLESS")})
      if(is.list(test_open)){test_open <-"SELENIUM_STANDALONE_LAUNCHED_SUCCESSFULLY : headless= TRUE browser=CHROME"}
      Sys.sleep(2)

    }else{
      Sys.sleep(1)
      remDr <- remoteDriver(remoteServerAddr="localhost",port=port,browserName="chrome")
      Sys.sleep(3)
      test_open <- tryCatch(remDr$open(),error=function(e){return("ERROR_LAUNCHING_SELENIUM_STANDALONE_GUI")})
      if(is.list(test_open)){test_open <-"SELENIUM_STANDALONE_LAUNCHED_SUCCESSFULLY : headless= FALSE browser= CHROME"}
    }
  }

    Sys.sleep(1.5)
    success <- FALSE
    #tryCatch({remDr$navigate("http://www.google.com");Sys.sleep(3);tester<- unlist(remDr$getTitle());Sys.sleep(1);if(tester=="Google"){return("SELENIUM_LAUNCHED_SUCCESSFULLY")}else{return("ERROR_LAUNCHING_SELENIUM")}},error=function(e){return("ERROR_LAUNCHING_SELENIUM")})
    tester <- tryCatch({remDr$navigate("http://www.google.com")},error=function(e){return("ERROR_LAUNCHING_SELENIUM")})
    Sys.sleep(1)
    if(is.null(tester)){tester <- "SELENIUM_STANDALONE_LAUNCHED_SUCCESSFULLY"}
    if(grepl("SUCCESS",tester)){
      print("SUCCESSFULLY LAUNCHED STANDALONE SELENIUM")
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
    print(paste0("SUCCESS= ",success))
    return(remDr)
  }else{
    return(print("FAILED_SELENIUM_STANDALONE_LAUNCH"))
  }
}



