#' reup function
#'
#' restart R, uninstall, and reinstall a package
#' @param package package to reinstall
#' @param github_user github user to install package from if installing from github (to install from CRAN, set github_user=NA) (default: nealbotn)
#' @param auth_token github authentication token if applicable for private github packages
#' @export
reup <- function(package="webbium", github_user="nealbotn",auth_token=NA, lib="default"){
  depack()
  Sys.sleep(1)
  if(lib=="default"){lib<-.libPaths()[1]}
  try(remove.packages(package, lib=lib))
  if(is.na(github_user)){
    install.packages(package,lib=lib)
  }else{
    invisible(if(!require("remotes")){install.packages("remotes")})
    if(is.na(auth_token)){
      remotes::install_github(paste0(github_user,"/",package),upgrade="never")
    }else{
      remotes::install_github(paste0(github_user,"/",package),auth_token = auth_token, upgrade="never")
    }
  }
  library(package, character.only = T)
}



