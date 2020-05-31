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

## Download based on Quadrats 
final_list <- list(data.frame(), data.frame(), data.frame(), data.frame(),data.frame(), data.frame())

for(i in 1:6){
    dfTemp <- city_list[[i]]
    for(j in 1:6){
quadratTemp <- occ_search(taxonKey = 6, country= canCode, hasCoordinate=T, return="data", ## select plants, in Canada, with coordinates
                     limit=50000, ## set  limit for downloading records
                     geometry = wicket::sp_convert(dfTemp[j])) ## specify first quadrat
       if(is.null(nrow(quadratTemp == TRUE))) {next}

           quadratTemp[,"quadrat"] <- rep(j, nrow(quadratTemp))
           allquadrats <- 	plyr::rbind.fill(allquadrats, quadratTemp)
           allquadrats <- allquadrats[,!apply(allquadrats, 2, function(x) sum(is.na(x))/nrow(allquadrats))>.20] ## Drop colimns with lots of NAs >20% 
            print(j)
    }
    final_list[[i]] <- allquadrats
}

## Save each GBIF data for each city
van1 <- final_list[[1]][1:50419,]
van2 <- final_list[[1]][50420:100838,]
write.csv(van1, "data/gbif/VancouverTransect_1.csv", row.names=FALSE)
write.csv(van2, "data/gbif/VancouverTransect_2.csv", row.names=FALSE)

edm1 <- final_list[[2]][1:51024,]
edm2 <- final_list[[2]][51025:102049,]
write.csv(edm1, "data/gbif/EdmontonTransect_1.csv", row.names=FALSE)
write.csv(edm2, "data/gbif/EdmontonTransect_2.csv", row.names=FALSE)

win1 <- final_list[[3]][1:51450,]
win2 <- final_list[[3]][51451:102900,]
write.csv(win1, "data/gbif/WinnipegTransect_1.csv", row.names=FALSE)
write.csv(win2, "data/gbif/WinnipegTransect_2.csv", row.names=FALSE)

tor1 <- final_list[[4]][1:54022,]
tor2 <- final_list[[4]][54023:108044,]
write.csv(tor1, "data/gbif/TorontoTransect_1.csv", row.names=FALSE)
write.csv(tor2, "data/gbif/TorontoTransect_2.csv", row.names=FALSE)

mtl1 <- final_list[[5]][1:57651,]
mtl2 <- final_list[[5]][57652:115302,]
write.csv(mtl1, "data/gbif/MontrealTransect_1.csv", row.names=FALSE)
write.csv(mtl2, "data/gbif/MontrealTransect_2.csv", row.names=FALSE)

hal1 <- final_list[[6]][1:60195,]
hal2 <- final_list[[6]][60196:120391,]
write.csv(hal1, "data/gbif/HalifaxTransect_1.csv", row.names=FALSE)
write.csv(hal2, "data/gbif/HalifaxTransect_2.csv", row.names=FALSE)


## Create species list for each quadrat with number of occurrences
speciesList_van <- final_list[[1]] %>% group_by( quadrat, scientificName) %>% summarize(count=length(scientificName))
speciesList_edm <- final_list[[2]] %>% group_by( quadrat, scientificName) %>% summarize(count=length(scientificName))
speciesList_win <- final_list[[3]] %>% group_by( quadrat, scientificName) %>% summarize(count=length(scientificName))
speciesList_tor <- final_list[[4]] %>% group_by( quadrat, scientificName) %>% summarize(count=length(scientificName))
speciesList_mtl <- final_list[[5]] %>% group_by( quadrat, scientificName) %>% summarize(count=length(scientificName))
speciesList_hal <- final_list[[6]] %>% group_by( quadrat, scientificName) %>% summarize(count=length(scientificName))

write.csv(speciesList_van, "data//VancouverSpeciesList.csv", row.names=FALSE)
write.csv(speciesList_edm, "data//EdmontonSpeciesList.csv", row.names=FALSE)
write.csv(speciesList_win, "data//WinnipegSpeciesList.csv", row.names=FALSE)
write.csv(speciesList_tor, "data//TorontoSpeciesList.csv", row.names=FALSE)
write.csv(speciesList_mtl, "data//MontrealSpeciesList.csv", row.names=FALSE)
write.csv(speciesList_hal, "data//HalifaxSpeciesList.csv", row.names=FALSE)
