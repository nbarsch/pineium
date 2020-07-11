#' rpn()
#'
#' remove punct/number and get only text
#'
#' @export
rpn <- function(string,both=TRUE){
  return(trimws(gsub("[[:digit:]]","",gsub("[[:punct:]]","",string))))
}
