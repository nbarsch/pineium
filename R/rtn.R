#' rtn()
#'
#' remove text/number and get only punct
#'
#' @export
rtn <- function(string){
  return(trimws(gsub("[[:alpha:]]","",gsub("[[:digit:]]","",string))))
}
