#' launchRD
#'
#' Primary selenium browser launcher
#' @param browser chrome or firefox
#' @param ext extension filepath to add
#' @param opt options to add (nosand=no sandbox; disnot=disable notifications; dispop=disable popups)
#' @param winsize set window size of bot
#' @param port  port number
#' @param timeout_pageload set a page load timeout in seconds, use a number without quotes as a number of seconds to set as timeout (default: 300 seconds)
#' @param timeout_script set a script load timeout in seconds, use a number without quotes as a number of seconds to set as timeout (default: 30 seconds)
#' @param timeout_implicit set a time to wait to find elements if not immediately available on page, use a number without quotes as number of seconds to set as timeout (default: 0, do not wait any time for elements not immediatly available)
#' @export
launchRD <- function(timeout_pageload="default", timeout_script="default",timeout_implicit="default",browser="chrome",cver="AUTO",adblock=FALSE, adblock_filepath=paste0(getwd(),"/adblock.crx"),notrack=TRUE, winsize= c(1280,800),browserargs=c("nosand","dispop","disnot"),headless=F, port=4567){
  library(pineium)
  library(RSelenium)
  library(stringr)
  library(wdman)
  library(binman)
  if(grepl("AUTO",toupper(cver))){
    cvers <- unlist(binman::list_versions("chromedriver"))
    if(length(cvers)>1){
      cvertwo <- substr(cvers,1,2)
      cvertwo <- unique(cvertwo)
      if(length(cvertwo)>2){
        cvert <- cvertwo[2]
      }else{
        cvert <- cvertwo[1]
      }
      cvers <- cvers[substr(cvers,1,2)==cvert]
      if(length(cvers)>1){cvers<-cvers[1]}
    }
    cver <- as.character(cvers[1])
  }
  if(isTRUE(headless)){
    if(!("/home/neal/rpack"%in%.libPaths())){.libPaths("/home/neal/rpack")}
    suppressWarnings(rm(remDr))
    suppressWarnings(rm(rD))
    gc()
    library(einium)
    library(curl)
    system(paste0("kill -9 $(lsof -t -i:",port," -sTCP:LISTEN)"))
    #if(!exists("cver")){cver <-"77.0.3865.40" }
    library(RSelenium)
    #library(devtools)
    eCaps <- list(chromeOptions = list(
      args = c('--headless', '--disable-gpu', '--window-size=1280,800')
      #extensions=list(base64enc::base64encode("/home/neal/tec_fblikes/alertblock.crx"))
    ))
    rD <- chrome(version=cver,port=as.integer(port))
    remDr <- remoteDriver(browserName="chrome",port=port)
    #remDr <- remoteDriver(browserName="chrome",port=4567L, extraCapabilities=eCaps)
    rs()
    remDr$open()
    rs()
    print(paste0("list item 1: rD"))
    print(paste0("list item 2: remDr"))

  }else{


    testsys <- Sys.info()["sysname"]

    #if(tolower(testsys)=="linux"){
    #  sysos <- "linux"
    #  cver <- system("google-chrome-stable --version")
    #  cver <- gsub("[[:alpha:]]","",cver)
    #  cver <- trimws(cver)
    #}else{
    #  if(tolower(testsys)=="windows"){
    #    sysos <- "windows"
    #    cver <- "77.0.3865.40"
    #  }else{
    #    sysos <- "mac"
    #    cver <- system("/Applications/Google\\ Chrome.app/Contents/MacOS/Google\\ Chrome --version",intern=T)
    #    cver <- gsub("[[:alpha:]]","",cver)
    #    cver <- trimws(cver)
    #  }
    #}
    tryCatch(rD$stop(),error=function(e){})
    tryCatch(remDr$close(),error=function(e){})
    suppressWarnings(rm(remDr))
    suppressWarnings(rm(remDr,envir = .GlobalEnv))
    suppressWarnings(rm(rD))
    suppressWarnings(rm(rD,envir = .GlobalEnv))
    gc()

    rs()
    library(binman)
    library(wdman)
    library(RSelenium) #install_github("ropensci/RSelenium")
    #cprof <- list(chromeOptions =
    #                list(extensions =
    #                       list(base64enc::base64encode("/home/neal/Desktop/browserPlugs/browserPlugs.crx"))
    #                ))
    system(paste0("kill -9 $(lsof -t -i:",port," -sTCP:LISTEN)"))
    if("nosand"%in%browserargs){cargs<-c("--no-sandbox")}else{cargs<-c()}
    if("disnot"%in%browserargs){cargs <- c(cargs,"--disable-notifications")}
    if("dispop"%in%browserargs){cargs <- c(cargs,"--disable-popup-blocking")}
    w1 <- winsize[1]
    w2 <- winsize[2]
    if(is.numeric(w1) & is.numeric(w2)){
      windowsize <- paste0("--window-size=",w1,",",w2)
      cargs <- c(cargs,windowsize)
    }
    if(isTRUE(adblock)){
      eCaps <- list(
        chromeOptions = list(
          args = cargs,
          prefs = list(
            "enable_do_not_track" = notrack
          ),
          extensions=list(base64enc::base64encode(adblock_filepath))

        )
      )
    }else{
      eCaps <- list(
        chromeOptions = list(
          args = cargs,
          prefs = list(
            "enable_do_not_track" = notrack
          )
        )
      )
    }

    rD <- chrome(version=cver,port=as.integer(port))
    #remDr <- remoteDriver(browserName="chrome",port=4567L)
    remDr <- remoteDriver(browserName="chrome",port=port, extraCapabilities=eCaps)
    rs()
    remDr$open()
    rs()
    print(paste0("USING chromedriver version: ",cver ))
    print(paste0("list item 1: rD"))
    print(paste0("list item 2: remDr"))
  }
  if(is.numeric(timeout_pageload)){
    remDr$setTimeout(type="page load",milliseconds=timeout_pageload*1000)
  }
  if(is.numeric(timeout_implicit)){
    remDr$setTimeout(type="implicit",milliseconds=timeout_implicit*1000)
  }
  if(is.numeric(timeout_script)){
    remDr$setTimeout(type="script",milliseconds=timeout_pageload*1000)
  }
  return(list(rD,remDr))
}
