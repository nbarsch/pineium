#' rpack
#'
#' Check for and install vector of packages if missing
#' @param package_vector String vector of packages to check for and install if missing
#' @export
rpack <- function(package_vector=c("data.table","dplyr","stringr","qdapRegex","foreach","lubridate")){
  suppressWarnings(if(!("foreach" %in% as.character(installed.packages()))){install.packages("foreach",repos='http://cran.us.r-project.org')})
  library(foreach)
  foreach(ipv=1:length(package_vector))%do%{
    tempx <- as.character(package_vector[ipv])
    suppressWarnings(if(!(tempx %in% as.character(data.frame(installed.packages())$Package))){install.packages(as.character(tempx),repos='http://cran.us.r-project.org')})
    reqinstall <- tempx %in% as.character(installed.packages())
    if(isTRUE(reqinstall)){print(paste0(as.character(tempx)," SUCCESSFULLY LOADED"))}else{print(paste0(as.character(tempx)," FAILED"))}
  }
}
