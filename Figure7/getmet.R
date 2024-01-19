

library(curl)
mypath=getwd()


getMet <- function (year = 2003, month = 6, path_met = getwd()) {
  require(curl)
  if(length(path_met)==0) path_met <- getwd()
  base <- "ftp://arlftp.arlhq.noaa.gov/archives/reanalysis/RP"
  for (i in seq_along(year)) {
    for (j in seq_along(month)) {
      url <- paste0(base, year[i], sprintf("%02d", month[j]), ".gbl")
      dest <- paste(mypath,basename(url),sep="/")
      curl_fetch_disk(url, dest)
    }
  }
}

for (k in 4){ 
  for (y in 1960:2013) {
    getMet(year=y, month=k)
  }
}

