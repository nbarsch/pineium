#' lit_local()
#'
#' Primary selenium browser launcher
#' @param browser chrome or firefox
#' @param port  port number
#' @param headless logical (TRUE or FALSE, no quotes) browse headlessly?
#' @export
lit_local <-function(port=4445,browser="chrome",headless=FALSE, chrome_profpath=NA,firefox_profpath=NA){

  os <- tolower(Sys.info()[["sysname"]])
  if(os!="windows"){
    Sys.sleep(1)
    port <- as.integer(port)
    system(paste0("kill -9 $(lsof -t -i:",port," -sTCP:LISTEN)"))
    system(paste0("kill -9 $(lsof -t -i:",port+1," -sTCP:LISTEN)"))
    system(paste0("kill -9 $(lsof -t -i:",port-1," -sTCP:LISTEN)"))
    Sys.sleep(1)
  }
  library(RSelenium)

  if(!is.na(firefox_profpath)){
    fprof <- getFirefoxProfile(firefox_profpath)
    rD <- rsDriver(port=as.integer(port),browserName="firefox",extraCapabilities=eCaps)
    remDr <- rD$client
  }
  if(!is.na(chrome_profpath)){
    fprof <- getChromeProfile(chrome_profpath)
    rD <- rsDriver(port=as.integer(port),browserName="chrome",extraCapabilities=eCaps)
    remDr <- rD$client
  }
  if(is.na(firefox_profpath) & is.na(chrome_profpath)){

    if(browser=="chrome" & headless==FALSE){
      try(rD <- rsDriver(port=as.integer(port),browser=browser,chromever = binman::list_versions("chromedriver")[[1]][1]))
      remDr <- rD$client
    }

    if(browser=="chrome" & headless==TRUE){
      eCaps <- list(chromeOptions = list(
        args = c('--headless', '--disable-gpu', '--window-size=1280,800',"--no-sandbox","--disable-notifications", "--disable-popup-blocking")
        #extensions=list(base64enc::base64encode("/home/neal/tec_fblikes/alertblock.crx"))
      )
      )
      try(rD <- rsDriver(port=as.integer(port),browser=browser,extraCapabilities=eCaps, chromever = binman::list_versions("chromedriver")[[1]][1]))
      remDr <- rD$client
    }

    if(browser=="firefox" & headless==TRUE){
      eCaps = list(
        "moz:firefoxOptions" = list(
          args = list('--headless')
        )
      )
      rD <- rsDriver(port=as.integer(port),browser="firefox",extraCapabilities=eCaps)
      remDr <- rD$client
    }

    if(browser=="firefox" & headless==FALSE){
      rD <- rsDriver(port=as.integer(port),browser="firefox")
      remDr <- rD$client
    }
  }
  return(remDr)
}

