#' allchar
#'
#' Convert data to all character columns
#' @param data
#' @export
allchar <- function(data){
  require(dplyr)
  data %>% mutate_all(as.character)->datachar
  return(datachar)
}

