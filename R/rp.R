#' rp()
#'
#' remove punct from string
#'
#' @export
rp <- function(string){
  return(trimws(gsub("[[:punct:]]","",string)))
}
