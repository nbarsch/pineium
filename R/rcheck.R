#' rcheck
#'
#' Check for and install package if missing
#' @param package
#' @export
rcheck <- function(package="data.table",github_user="NA"){
  if(package %in% installed.packages()){
    return(paste0(package," INSTALLED AND READY TO USE"))
  }else{
      if(github_user=="NA"){
        install.packages(package)
      }else{
        suppressWarnings(if(!require("remotes")){install.packages("remotes")})
        remotes::install_github(paste0(github_user,"/",package))
      }
      if(package %in% installed.packages()){
        return(paste0(package," INSTALLED AND READY TO USE"))
      }else{return(paste0(package," INSTALL FAILED"))}
  }



  if(!all(as.logical(sapply(as.character(package_vector),FUN=function(x){x%in%data.frame(installed.packages())$Package})))){
  suppressWarnings(if(!("foreach" %in% as.character(installed.packages()))){install.packages("foreach",repos='http://cran.us.r-project.org')})
  for(ipv in c(1:length(package_vector))){
    tempx <- as.character(package_vector[ipv])
    if(length(tempx)>1){tempx <- tempx[1]}
    suppressWarnings(if(!(tempx %in% as.character(data.frame(installed.packages())$Package))){install.packages(as.character(tempx))})
    reqinstall <- tempx %in% as.character(installed.packages())
    if(isTRUE(reqinstall)){
      print(paste0(as.character(tempx)," SUCCESSFULLY LIBRARIED"))
      library(tempx,character.only=TRUE)
      }else{print(paste0(as.character(tempx)," FAILED"))}
  }
  }else{
    for(ip in c(1:length(package_vector))){
      reqinstall <- package_vector[ip] %in% as.character(installed.packages())
      if(isTRUE(reqinstall)){
        print(paste0(package_vector[ip]," SUCCESSFULLY LIBRARIED"))
        library(package_vector[ip],character.only=TRUE)
      }else{print(paste0(package_vector[ip]," FAILED"))}
    }
  }
}
