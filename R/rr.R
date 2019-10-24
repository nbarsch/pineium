#' rr()
#'
#' remove punct/txt and get only number
#'

#' @export
rr <- function(text,both=TRUE){
  if(!is.logical(both)){
    if(grepl("a",both)){
      return(gsub("[[:alpha:]]","",text))
    }
    if(grepl("p",both)){
      return(gsub("[[:punct:]]","",text))
    }
  }else{
    return(gsub("[[:alpha:]]","",gsub("[[:punct:]]","",text)))
  }
}
