#' rtn()
#'
#' remove num/text and get only punct
#'
#' @export
rtn <- function(string,both=TRUE){
  return(trimws(gsub("[[:alpha:]]","",gsub("[[:digit:]]","",string))))
}
