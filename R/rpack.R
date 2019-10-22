#' rpack
#'
#' Check for and install vector of packages if missing
#' @param package_vector String vector of packages to check for and install if missing
#' @export
rpack <- function(package_vector=""){
  if(package_vector==""){package_vector<-c("data.table","dplyr","foreach","stringr","readr","qdapRegex","rvest","httr","RSelenium","XML","xml2")}
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
