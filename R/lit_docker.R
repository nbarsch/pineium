#' lit_docker()
#'
#' Primary selenium browser launcher
#' @param browser chrome or firefox
#' @param port  port number
#' @param headless MUST BE =TRUE FOR USING DOCKER
#' @export
lit_docker <-function(port=4445,browser="chrome",headless=TRUE){
  if(headless==FALSE){
    print("NOTE: WHEN USING DOCKER YOU ARE REQUIRED TO RUN HEADLESS, OVERRIDING AND USING headless=TRUE")
    Sys.sleep(2)
  }
  os <- tolower(Sys.info()[["sysname"]])
  if(os!="windows"){
    Sys.sleep(1)
    port <- as.integer(port)
    Sys.sleep(1)
    system("sudo docker stop $(sudo docker ps -a -q)")
    Sys.sleep(1)
    system("sudo docker rm $(sudo docker ps -a -q)")
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
    system(paste0('sudo docker run -d -p ',port,":",port-1,' selenium/standalone-', browser))
    Sys.sleep(6)
  }
  if(browser=="chrome"){

    remDr <- remoteDriver(port=as.integer(port),browserName="chrome")
    Sys.sleep(10)
    remDr$open()
    Sys.sleep(5)

  }else{

    remDr <- remoteDriver(port=as.integer(port),browserName="firefox")
    Sys.sleep(10)
    remDr$open()
    Sys.sleep(5)
  }
  remDr$navigate("https://www.duckduckgo.com")
  Sys.sleep(1)
  return(remDr)
}


