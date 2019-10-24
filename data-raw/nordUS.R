library(data.table)
nordUS <- fread("data-raw/nordUS.csv")
devtools::use_data(nordUS,overwrite=T)
