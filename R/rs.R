#' rs
#'
#' System sleep for a random amount of time, to .001 seconds, between two limits min/max (seconds)
#'
#' @param min min sleep time
#' @param max max sleep time
#' @export
rs <- function(min=1,max=2){
  randsleep <- sample(seq(min, max, by = 0.001),1)
  Sys.sleep(randsleep)
}
