#' rpn()
#'
#' remove punct/number and get only text
#'
#' @export
rpn <- function(string){
  return(trimws(gsub("[[:digit:]]","",gsub("[[:punct:]]","",string))))
}
