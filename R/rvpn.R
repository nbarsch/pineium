#' rvpn()
#'
#' redo vpn connection (linux only)
#' @param trem test using cnn connection speed
#' @param trem_time max connection time or else reset
#' @param server if you want to add "hops" for denver or a nord us4405.nordvpn.com
#' @param test_site what test site to use to test browser speed (default cnn.com)
#' @export
rvpn <- function(trem=TRUE, trem_time=10,vpn="windscribe",server="default", test_site="https://cnn.com"){
  rdone <- FALSE
  while(rdone==FALSE){
    dip <- FALSE
    while(dip==FALSE){
      tip <- system("curl ifconfig.me", intern=T)
      system(paste0(vpn," disconnect"))
      Sys.sleep(2)
      if(server=="default"){
        system(paste0(vpn," connect"))
      }else{
        system(paste0(vpn," connect ", server))
      }
      Sys.sleep(2)
      tip2 <- system("curl ifconfig.me", intern=T)
      if(tip!=tip2){dip <- TRUE}
    }

    if(isTRUE(trem)){
      remDr <- get("remDr")
      stest <- system.time(remDr$navigate(paste0(test_site)))
      snum <- as.numeric(stest[3])
      print(paste0("test time load: ",snum))
      if(snum<trem_time){rdone <- TRUE}else{rdone <- FALSE}
    }
  }
}
