#' kX1
#'
#' Delete all columns in data object (data.table, data.frame, or tibble) from data
#'
#' @param x Object to be tested

#' @export
kX1 <- function(data){
  setDT(data)
  killcols <- which(substr(names(data),1,1)=="X")
  if(length(killcols)>0){
    data <- data[,(c(killcols)):=NULL,]
  }
  return(data)
}
