#' rpack
#'
#' Check for and install vector of packages if missing
#' @param package_vector String vector of packages to check for and install if missing
#' @export
rpack <- function(package_vector=c("data.table","dplyr","stringr","qdapRegex","foreach","lubridate")){
  suppressWarnings(if(!("foreach" %in%installed.packages())){install.packages("foreach")})
  foreach(ipv=1:length(package_vector))%do%{
    tempx <- as.character(package_vector[ipv])
    suppressWarnings(if(!(tempx %in%installed.packages())){install.packages(as.character(tempx))})
    reqinstall <- tempx %in% installed.packages()
    if(isTRUE(requinstall)){print(paste0(as.character(tempx)," SUCCESSFULLY LOADED"))}else{print(paste0(as.character(tempx)," FAILED"))}
  }
}
