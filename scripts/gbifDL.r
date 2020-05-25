## Download from GBIF
# install.packages("rgbif")
library(rgbif)
library(tidyverse)

## Load libraries for spatial data
library(rgdal)
library(spdep)
library(leaflet)

#### Download code for Canada

## Determine key for Canada
canCode <- isocodes[grep("Canada", isocodes$name), "code"]
occ_count(country=canCode) ## 71319394 occurrences in Canada

## Determine key for plants
plants <- name_lookup(query='plantae') ## use Nub/kingdom key

## search for plants in Canada
nrecord <- occ_search(taxonKey = 6, country= canCode, hasCoordinate=T) ## 1821428 records 

## Download occurrences
allspp <- occ_search(taxonKey = 6, country= canCode, hasCoordinate=T, return="data", ## select plants, in Canada, with coordinates
                     limit=1000, ## set  limit for downloading records
                     geometry = 'POLYGON((-80 43, -80 44, -79 44, -79 43, -80 43))') ## specify for area around Toronto - WKT polygon counter clockwise


## Assign points to dataframe                   
torOcc <-  allspp %>% data.frame()

## Plot occurrences around Toronto
leaflet() %>% addTiles() %>% addCircleMarkers(lng = torOcc$decimalLongitude, lat = torOcc$decimalLatitude, radius=5)