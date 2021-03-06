% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/reup.R
\name{reup}
\alias{reup}
\title{reup function}
\usage{
reup(
  package = "webbium",
  github_user = "nealbotn",
  auth_token = NA,
  lib = "default"
)
}
\arguments{
\item{package}{package to reinstall}

\item{github_user}{github user to install package from if installing from github (to install from CRAN, set github_user=NA) (default: nealbotn)}

\item{auth_token}{github authentication token if applicable for private github packages}
}
\description{
restart R, uninstall, and reinstall a package
}
