setwd("/Volumes/LaCie SSD/TrajData")
main.dir=getwd()
library(splitr)
library(lubridate)
library(here)
library(raster)
library(mapdata)
library(sf)
library(magrittr)
i_am("splitr.R")


for (site in c("GB", "FER", "CAN")) {
if (site=="GB") {lat=53.3; lon=-60.33; xy.gb=c()}
if (site=="FER") {lat=52.78; lon=-67.08; xy.fer=c()}
if (site=="CAN") {lat=54.45; lon=-70.5; xy.can=c()}
H=200
D=24
#Season="spring" 
Season="summer"
myfile=paste(site, "_winds_", Season, "_H_", H, "_D_", D, ".pdf", sep="")
pdf(file=myfile)

if (Season=="spring") {
  my.start="-04-10"
  my.end="-06-29"
} else { 
  my.start="-06-29"
  my.end="-09-07"
}

xy=c()
for (i in as.character(1960:2013)) {
  myyear=i
  mydate_start=paste(myyear, my.start, sep="")
  mydate_end=paste(myyear, my.end, sep="")
  trajectory <- 
    hysplit_trajectory(
      lat = lat,
      lon = lon,
      height = H,
      duration = D,
      days = seq(as.Date(mydate_start), as.Date(mydate_end), by="days"),
      daily_hours = c(18),
      direction = "backward",
      met_type = "reanalysis",
      extended_met = TRUE,
      met_dir = here::here("met"),
      exec_dir = here::here("out")
    ) 
  if (site=="GB")  {xy=rbind(xy, as.matrix(trajectory[,c("hour_along", "lon", "lat")])); xy.gb=xy}
  if (site=="FER") {xy=rbind(xy, as.matrix(trajectory[,c("hour_along", "lon", "lat")])); xy.fer=xy}
  if (site=="CAN") {xy=rbind(xy, as.matrix(trajectory[,c("hour_along", "lon", "lat")])); xy.can=xy}
  }

  #Select origin
  xy=xy[which(xy[,"hour_along"]==-D),][,-1]
  region=c(xmn=-80, ymn=40, xmx=-40, ymx=70)

  r <- raster(xmn=region["xmn"], ymn=region["ymn"], xmx=region["xmx"], ymx=region["ymx"], res=1)
  r[] <- 0
  
  tab <- table(cellFromXY(r, xy))
  r[as.numeric(names(tab))] <- tab

  cr=colorRampPalette(c("white","blue", "red"))
  plot(NA, xlim=c(region["xmn"], region["xmx"]), ylim=c(region["ymn"], region["ymx"]), main=site)
  plot(r, xlim=c(region["xmn"], region["xmx"]), ylim=c(region["ymn"], region["ymx"]),add=TRUE, gridded=TRUE, col=cr(20))
  map(xlim=c(region["xmn"], region["xmx"]), ylim=c(region["ymn"], region["ymx"]), add=TRUE)
  points(lon, lat, pch=10, cex=2, col="white")
  dev.off()
}




