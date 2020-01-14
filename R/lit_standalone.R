#' lit_standalone()
#'
#' Primary selenium browser launcher
#' @param browser chrome or firefox
#' @param port  port number
#' @param headless logical (TRUE or FALSE, no quotes) browse headlessly?
#' @export
lit_standalone <-function(browser="chrome", port=4445,headless=FALSE, firefox_profpath=NA,chrome_profpath=NA){
  library(RSelenium)
  library(wdman)
  library(binman)
  library(pineium)
  library(curl)
  os <- tolower(Sys.info()[["sysname"]])
  if(os!="windows"){
    Sys.sleep(1)
    port <- as.integer(port)
    system(paste0("kill -9 $(lsof -t -i:",port," -sTCP:LISTEN)"))
    system(paste0("kill -9 $(lsof -t -i:",port+1," -sTCP:LISTEN)"))
    system(paste0("kill -9 $(lsof -t -i:",port-1," -sTCP:LISTEN)"))
    Sys.sleep(1)
  }

  if(os!="windows"){
    #if(browser=="chrome"){
    #  system("sudo apt-get install chromium-chromedriver -y")
    #}

    if(!dir.exists("tempjar")){dir.create("tempjar")}
    Sys.sleep(1)
    if(!file.exists(paste0(getwd(),"/tempjar/selenium-server-standalone-3.141.59.jar"))){
      download.file(url="https://selenium-release.storage.googleapis.com/3.141/selenium-server-standalone-3.141.59.jar",destfile="tempjar/selenium-server-standalone-3.141.59.jar")
      Sys.sleep(2)
      system(paste0("unzip -o ",getwd(),"/tempjar/selenium-server-standalone-3.141.59.jar -d ",getwd(),"/tempjar/"), wait=T)
      Sys.sleep(1)
      Sys.setenv(Dwebdriver.chrome.driver=paste0(getwd(),"/tempjar/selenium-server-standalone-3.141.59.jar"))
      Sys.sleep(1)
    }
    if(browser=="firefox" & (!file.exists(paste0(getwd(),"/tempjar/geckodriver")))){
      btype <- Sys.info()[["machine"]]
      if(grepl("32",btype)){btype <- "32bit"}
      if(grepl("arm",btype)){btype<-"32bit"}
      if(btype=="32bit"){
        download.file(url="https://github.com/mozilla/geckodriver/releases/download/v0.17.0/geckodriver-v0.17.0-linux32.tar.gz",destfile="tempjar/geckodriver-v0.17.0-linux32.tar.gz")
      }else{
        download.file(url="https://github.com/mozilla/geckodriver/releases/download/v0.26.0/geckodriver-v0.26.0-linux64.tar.gz",destfile="tempjar/geckodriver-v0.26.0-linux64.tar.gz")
      }

      geckloc <- list.files("tempjar/","geckodriver",full.names=T)
      geckloc <- geckloc[str_sub(geckloc,-2,-1)=="gz"]
      system(paste0("tar -xvzf ",geckloc))
      system("sudo mv geckodriver tempjar/geckodriver")
      system("sudo chmod +x tempjar/geckodriver")
      Sys.setenv(Dwebdriver.gecko.driver=paste0(getwd(),"/tempjar/geckodriver"))
      Sys.sleep(1)
    }
  }
  Sys.sleep(1)
  system(paste0("java -jar ",getwd(),"/tempjar/selenium-server-standalone-3.141.59.jar -port ",port), wait=F)
  Sys.sleep(1)

  if(browser=="chrome"){

    if(isTRUE(headless)){
      eCaps <- list(chromeOptions = list(
        args = c('--headless', '--disable-gpu', '--window-size=1280,800',"--no-sandbox","--disable-notifications", "--disable-popup-blocking")
        #extensions=list(base64enc::base64encode("/home/neal/tec_fblikes/alertblock.crx"))
      )
      )
    }else{
      if(!is.na(chrome_profpath)){
        eCaps <- getChromeProfile(chrome_profpath)
      }else{
        eCaps <- list(chromeOptions = list(
          args = c("--no-sandbox","--disable-notifications", "--disable-popup-blocking")
        ))
      }
    }
    remDr <- remoteDriver(remoteServerAddr="localhost",port=port,browserName="chrome", extraCapabilities=eCaps)
    Sys.sleep(3)
    remDr$open()
    Sys.sleep(3)

  }else{
    if(isTRUE(headless)){
    eCaps = list(
      "moz:firefoxOptions" = list(
        args = list('--headless')
      )
    )
    remDr <- remoteDriver(remoteServerAddr="localhost",port=as.integer(port),browserName="firefox",extraCapabilities=eCaps)
    }else{
      if(!is.na(firefox_profpath)){
        if(firefox_profpath=="make"){
        fprof <- makeFirefoxProfile(
          list(
            "browser.cache.disk.enable" = FALSE,
            "browser.cache.memory.enable" = FALSE,
            "browser.cache.offline.enable" = FALSE,
            "network.http.use-cache" = FALSE
          )
        )
        }else{
          fprof <- getFirefoxProfile(firefox_profpath)
        }
        remDr <- remoteDriver(remoteServerAddr="localhost",port=as.integer(port),browserName="firefox",extraCapabilities=fprof)
        remDr$open()

      }else{
        remDr <- remoteDriver(remoteServerAddr="localhost",port=as.integer(port),browserName="firefox")
      }
    }
    Sys.sleep(5)
    remDr$open()
    Sys.sleep(5)
  }
  remDr$navigate("https://www.duckduckgo.com")
  Sys.sleep(1)
  return(remDr)

}
