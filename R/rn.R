#' rn()
#'
#' remove numbers from string
#'
#' @export
rn <- function(string){
  return(trimws(gsub("[[:digit:]]","",string)))
}
