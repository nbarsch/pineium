#' allchar
#'
#' Convert data to all character columns
#' @param data
#' @export
allchar <- function(data){
  dataobj <- get(data)
  require(dplyr)
  dataobj %>% mutate_all(as.character)->datachar
  return(datachar)
}

