#' authall
#' authenticate all for googleCloudStorageR and googleComputeEngineR
#'
#' @export
authall <- function(project="luxoydata", auth_json="/home/neal/redryzen_authin/luxoydata.json",zone="asia-east1-a"){
  Sys.setenv(GCS_AUTH_FILE= auth_json)
  library(googleCloudStorageR)

  Sys.setenv(GCE_AUTH_FILE= auth_json,
             GCE_DEFAULT_PROJECT_ID= project,
             GCE_DEFAULT_ZONE= zone)
  library(googleComputeEngineR)
}
