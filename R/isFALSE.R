#' isFALSE
#'
#' Adds isFALSE to R which is needed if using R version 3.3 or less
#'
#' @param x Object to be tested

#' @export
isFALSE <-function(x){is.logical(x) && length(x) == 1L && !is.na(x) && !x}

