#' launchRD
#'
#' Primary fb likes function
#' @param browser chrome or firefox
#' @param ext extension filepath to add
#' @param opt options to add (nosand=no sandbox; disnot=disable notifications; dispop=disable popups)
#' @param winsize set window size of bot
#' @param port  port number
#' @export
launchRD <- function(browser="chrome",cver="77.0.3865.40",adblock=FALSE, adblock_filepath=paste0(getwd(),"/adblock.crx"),notrack=TRUE, winsize= c(1280,800),browserargs=c("nosand","dispop","disnot"),headless=F, port=4444L){
  library(pineium)
  library(RSelenium)
  library(wdman)
  library(binman)
  if(isTRUE(headless)){
    if(!("/home/neal/rpack"%in%.libPaths())){.libPaths("/home/neal/rpack")}
    suppressWarnings(rm(remDr))
    suppressWarnings(rm(rD))
    gc()
    library(einium)
    library(curl)
    system("kill -9 $(lsof -t -i:4567 -sTCP:LISTEN)")
    if(!exists("cver")){cver <-"77.0.3865.40" }
    library(RSelenium)
    #library(devtools)
    eCaps <- list(chromeOptions = list(
      args = c('--headless', '--disable-gpu', '--window-size=1280,800')
      #extensions=list(base64enc::base64encode("/home/neal/tec_fblikes/alertblock.crx"))
    ))
    rD <- chrome(version=cver)
    #remDr <- remoteDriver(browserName="chrome",port=4567L,extraCapabilities=cprof)
    remDr <- remoteDriver(browserName="chrome",port=4567L, extraCapabilities=eCaps)
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
    system("kill -9 $(lsof -t -i:4567 -sTCP:LISTEN)")
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

    rD <- chrome(version=cver)
    #remDr <- remoteDriver(browserName="chrome",port=4567L,extraCapabilities=cprof)
    remDr <- remoteDriver(browserName="chrome",port=4567L, extraCapabilities=eCaps)
    rs()
    remDr$open()
    rs()
    print(paste0("list item 1: rD"))
    print(paste0("list item 2: remDr"))
  }
  return(list(rD,remDr))
}
