#' rpt()
#'
#' remove punct/text and get only number
#'
#' @export
rpt <- function(string){
  return(trimws(gsub("[[:alpha:]]","",gsub("[[:punct:]]","",string))))
}
