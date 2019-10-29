#' allchar
#'
#' Convert data to all character columns
#' @param data what data to convert
#' @export
allchar <- function(data){
  dataobj <- get(data)
  require(dplyr)
  dataobj %>% mutate_all(as.character)->datachar
  return(datachar)
}

