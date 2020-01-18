#' rvpn()
#'
#' redo vpn connection (linux only)
#' @param test test remDr speed
#' @export
rvpn <- function(trem=TRUE, trem_time=10,vpn="windscribe"){
  rdone <- FALSE
  while(rdone==FALSE){
    dip <- FALSE
    while(dip==FALSE){
      tip <- system("curl ifconfig.me", intern=T)
      system(paste0(vpn," disconnect"))
      Sys.sleep(2)
      system(paste0(vpn," connect"))
      Sys.sleep(2)
      tip2 <- system("curl ifconfig.me", intern=T)
      if(tip!=tip2){dip <- TRUE}
    }

    if(isTRUE(trem)){
      remDr <- get("remDr")
      stest <- system.time(remDr$navigate("https://cnn.com"))
      snum <- as.numeric(stest[3])
      print(paste0("test time cnn load: ",snum))
      if(snum<trem_time){rdone <- TRUE}else{rdone <- FALSE}
    }
  }
}
