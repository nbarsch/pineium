#' splitfixed
#'
#' Split string between two instances of "_"
#' @param x String
#' @param n first iteration of _
#' @param n last iteration of _
#' @export
splitfixed = function(x, n, i){
  do.call(c, lapply(x, function(X)
    paste(unlist(strsplit(X, "_"))[(n+1):(i)], collapse = "_")))
}
