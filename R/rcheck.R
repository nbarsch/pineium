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
}

