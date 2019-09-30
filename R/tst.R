#' tst()
#'
#' Generate a timestamp in milliseconds unique with same number of characters every time
#'

#' @export
tst <- function(){
  return(gsub("[[:alpha:]]","",gsub("[[:punct:]]","",milliseconds(as.numeric(Sys.time())))))
}
