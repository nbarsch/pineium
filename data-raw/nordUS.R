library(data.table)
library(devtools)
nordUS <- fread("data-raw/nordUS.csv")
devtools::use_data(nordUS,overwrite=T)
