#' lit()
#'
#' Primary selenium browser launcher that reads your system info automatically and tries a series of selenium launches, keeping the first one that works.
#' This function is designed to work across all operating system platforms AND 32-bit/64-bit infrastructure. Tested on 32-bit raspi4 with ubuntu 19.10, 64 bit ubuntu 18.04LTS, Mac (Darwin),and Windows 10
#' @param browser chrome or firefox
#' @param port  port number
#' @param headless logical (TRUE or FALSE, no quotes) browse headlessly?
#' @param foo_priority vector of "standalone","docker","local" (up to all three) in order of priority of use (i.e. if you want to use standalone, with docker as backup, use foo_priority=c("standalone","docker"))
#' @export
lit <- function(browser="chrome",port=4444,headless=FALSE,foo_priority=c("standalone","docker","local")){
  library(pineium)
  foodo <- FALSE
  os <- tolower(Sys.info()[["sysname"]])
  if(os=="windows"){
    foo_priority <- foo_priority[foo_priority!="docker"]
  }else{
    port <- as.integer(port)
    system(paste0("kill -9 $(lsof -t -i:",port," -sTCP:LISTEN)"))
    system(paste0("kill -9 $(lsof -t -i:",port+1," -sTCP:LISTEN)"))
    system(paste0("kill -9 $(lsof -t -i:",port-1," -sTCP:LISTEN)"))
    Sys.sleep(1)
  }
  while(foodo==FALSE){
    if(foo_priority[1]=="standalone"){
      remDr <- lit_standalone(browser=browser,port=port,headless=headless,retry_max=2)
    }
    if(foo_priority[1]=="docker"){
        remDr <- lit_docker(browser=browser,port=port,headless=headless,retry_max=2)
    }
    if(foo_priority[1]=="local"){
      remDr <- lit_local(browser=browser,port=port,headless=headless,retry_max=2)
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
      adone <- TRUE
    }else{
      success <- FALSE
      adone <- FALSE
      Sys.sleep(1)
    }
    if(adone==FALSE){
      if(length(foo_priority)>1){
        foo_priority <- foo_priority[2:length(foo_priority)]
      }
    }
    if(isTRUE(adone)){
      print(paste0("SUCCESSFUL_LAUNCH_WITH_",foo_priority[1]," browser=",toupper(browser)))
      foodo<-TRUE
    }
  }
  if(adone==FALSE){
    return(print("ERROR_LAUNCHING_SELENIUM_lit"))
  }else{
    return(remDr)
  }
}
