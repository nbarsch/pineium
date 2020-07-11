#' ts()
#'
#' Generate a timestamp in milliseconds unique with same number of characters every time
#'

#' @export
ts <- function(){
  return(gsub("[[:alpha:]]","",gsub("[[:punct:]]","",milliseconds(as.numeric(Sys.time())))))
}
