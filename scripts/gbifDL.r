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
vanQuadrat <- readRDS("data/transects/vancouver.rds")
edmQuadrat <- readRDS("data/transects/edmonton.rds")
winQuadrat <- readRDS("data/transects/winnipeg.rds")
torQuadrat <- readRDS("data//transects//toronto.rds")
mtlQuadrat <- readRDS("data/transects/montreal.rds")
halQuadrat <- readRDS("data/transects/halifax.rds")
city_list <- list(vanQuadrat, edmQuadrat, winQuadrat, torQuadrat, mtlQuadrat, halQuadrat)


## Write a function that downloads occurrences from polygons and create a polygon ID column
gbifDL <- function(polys, iter){ 
        polyTemp <- polys[iter]
        quadratTemp <- occ_search(taxonKey = 6, country= canCode, hasCoordinate=T, return="data", ## select plants, in Canada, with coordinates
                             limit=50000, ## set  limit for downloading records
                             geometry = wicket::sp_convert(polyTemp)) ## specify quadrat
        quadratTemp[,"quadrat"] <- rep(iter, nrow(quadratTemp))
        return(quadratTemp)
}

## Create a function that extracts each polygon
getQuadrats <- function(polys){
lapply(1:5,  FUN=function(i) {
    tryCatch(gbifDL(polys, i), error=function(e) NULL)
})
}

allTransects <- data.frame()
for(j in 1:length(city_list)){
    outQuadrat <- getQuadrats(city_list[[j]])
    tempQuadrats <- do.call( plyr::rbind.fill, outQuadrat)
    tempQuadrats[,"Transect"] <- j
    allTransects <- do.call( plyr::rbind.fill, list(allTransects, tempQuadrats))
    print(j)
}

### Remove extra columns to save sapce
allTransects <- allTransects[,!apply(allTransects, 2, function(x) sum(is.na(x))/nrow(allTransects))>.40] ## Drop columns with lots of NAs >40% 
cityID <- data.frame(Transect= c(1:6), City = c("Vancouver","Edmonton","Winnipeg","Toronto","Montreal","Halifax"))
allTransects <- merge(allTransects, cityID, by="Transect")

write.csv(allTransects, "data/gbif/AllTransect.csv", row.names=F)


## Create species list for each quadrat with number of occurrences
speciesList <- allTransects %>% group_by(City,  quadrat, species) %>% summarize(count=length(species))


write.csv(speciesList, "data//MasterSpeciesList.csv", row.names=FALSE)

