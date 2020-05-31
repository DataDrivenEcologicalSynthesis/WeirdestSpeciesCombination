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


#### Download data for transects
torQuadrat <- readRDS("data//transects//toronto.rds")

torQuadrat[1]

## Download based on Quadrats
allquadrats <- data.frame()
for(i in 1:6){
    quadratTemp <- occ_search(taxonKey = 6, country= canCode, hasCoordinate=T, return="data", ## select plants, in Canada, with coordinates
                              limit=50000, ## set  limit for downloading records
                              geometry = wicket::sp_convert(torQuadrat[i])) ## specify first quadrat
    quadratTemp[,"quadrat"] <- rep(i, nrow(quadratTemp))
    allquadrats <- 	plyr::rbind.fill(allquadrats, quadratTemp)
    print(i)
}

## Drop columns with lots of NAs >20%
allquadrats <- allquadrats[,!apply(allquadrats, 2, function(x) sum(is.na(x))/nrow(allquadrats))>.20]

## allquadrats
write.csv(allquadrats, "data//gbif//TorontoTransect.csv", row.names=FALSE)

## Create species list for each quadrat with number of occurrences
speciesList <- allquadrats %>% group_by( quadrat, scientificName) %>% summarize(count=length(scientificName))

write.csv(speciesList, "data//TorontoSpeciesList.csv", row.names=FALSE)
