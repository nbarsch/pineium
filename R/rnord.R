#' rnord
#' reset nord connection
#' @param nordserver default "random" which connects or reconnects to a random US server, optionally specify
#' @export
rnord <- function(nordserver="random", OS="linux"){
  if(tolower(OS)=="mac"){
    system("kill $(pgrep IKE)")
  }else{
    dcon1 <- system("nordvpn disconnect",intern=T)
  }
  rs()
  library(data.table)
  wrep <- 0
  testnord <- FALSE
  while(testnord==FALSE){
    wrep <- wrep+1
    if(nordserver!="random" & wrep<3){
      rs()
      if(tolower(OS)=="mac"){
        servest <- system("open -a /Applications/NordVPN\\ IKE.app", intern=T)
        rs(10,15)
      }else{
        tnord <- system(paste0("nordvpn connect ",nordserver))
        rs(5,6)
        testnord <- grepl("connected",paste(tnord,collapse=" "))
        rs()
      }
 
    }
    if(nordserver=="random" | wrep>3){
      if(wrep>3){print(paste0("Connection to desired server failed, connecting to random US server..."))}else{print(paste0("Connecting to random US server..."))}
      if(!file.exists("nordus.csv")){
        nordus <- download.file("https://raw.githubusercontent.com/nbarsch/nordUSserv/master/nordUSserv.csv",destfile="nordus.csv")
      }
      nordus <- fread("nordus.csv")
      nordsamp <- sample(nordus$domain,1,1)
      #library(pineium)
      nordsamp <- rr(nordsamp)
      samp_nord <- paste0("us",nordsamp)
      if(tolower(OS)=="mac"){
        system("kill $(pgrep IKE)")
      }else{
        dcon1 <- system("nordvpn disconnect",intern=T)
      }
      rs(5,8)
      if(tolower(OS)=="mac"){
        system("open -a /Applications/NordVPN\\ IKE.app")
        rs(10,15)
        testike <- system('ps axo pid,command | grep "IKE.app"',intern=T)
        testike <- testike[!grepl("grep",testike)]
        if(length(testike)>0){
          print("NORDVPN CONNECTED")
          testnord <- TRUE
          }
      }else{
        tnord <- system(paste0("nordvpn connect ",samp_nord), intern=T)
        rs(5,6)
        testnord <- grepl("connected",paste(tnord,collapse=" "))
        rs()
        nordstatus <- system("nordvpn status", intern=T)
        if(length(nordstatus>1)){
          print(paste0("pineium::rnord() successfull, connected to ",tolower(nordstatus[2])))
        }
      }

    }
  }
  rs()


}
