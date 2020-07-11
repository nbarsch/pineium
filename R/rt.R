#' rt()
#'
#' remove txt and get only number
#'
#' @export
rt <- function(string){
  return(trimws(gsub("[[:alpha:]]","",string)))
}
