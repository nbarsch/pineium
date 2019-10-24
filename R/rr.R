#' rr()
#'
#' remove punct/txt and get only number
#'
#' @export
rr <- function(text,both=TRUE){
  if(!is.logical(both)){
    if(grepl("a",both)){
      return(trimws(gsub("[[:alpha:]]","",text)))
    }
    if(grepl("p",both)){
      return(trimws(gsub("[[:punct:]]","",text)))
    }
  }else{
    return(trimws(gsub("[[:alpha:]]","",gsub("[[:punct:]]","",text))))
  }
}
