#### Generate Transects for Canadian cities

## Load libraries
library(raster)
# library(dismo) ## used to get Canada Polygon

## load fucntions
source("scripts//functions.r")

## Download polygon for Canada
# canPoly <- getData(name="GADM", country="CAN", level=1) ## run once for download
canPoly <- readRDS("data//gadm36_CAN.rds") ## load polygon
plot(canPoly) ## takes a while because all the islands 


## dataframe of lat, lon for cities
cities <- data.frame(city = c("Toronto"),
             lon = c(-79.3832),
             lat = c(43.6532))


## Create spatial dataframe
coordinates(cities) <- ~lon+lat # specify x and y columns
proj4string(cities) <- CRS("+proj=longlat +datum=WGS84") ## Need to use a CRS (I picked WGS84), for non-GIS folk, this does a good job explaining a CRS https://rspatial.org/raster/spatial/6-crs.html

## Notes
## a CRS of WGS84 has units in decimal degrees. The earth is circular so 1 decimal degree does not equal the same thing at different latitudes (e.g. higher latitudes smaller distances, latitudes closer to the equator are larger).
## Every degree away from the equator is equal to cosine of that latitude. 
deg2rad <- function(deg) {(deg * pi) / (180)} ## function converts decimal degrees to radians
lat2km <- function(lat){ cos(deg2rad(lat)) * 111.32 } ## cosine of latitude in radius multiplied by the size of the decimal at the equator

## Find out the units of km for decimal degrees at the latitude of Toronto
lat2km(43.6532) ## 1 decimal degree at Toronto is 80.5435

## Decimal degrees to 10 km buffer
resToronto <- 1/80.5435*10 ## 0.1241 decimal degrees  = 10 km 


## Create transect for Toronto
torontoTransect <- cityTransect(citylon = cities$lon, citylat = cities$lat, nquadrat = 6,  ## nquadrat is the number of quadrats
                                buffer=5, ## distance in km around the centroid of city to make the buffer. e.g. 5 = 10 x 10 km box with city as center
                                distance = 10) ## distance in km between buffered transects

## Plot to make sure it worked
plot(canPoly[canPoly$NAME_1=="Ontario",]) ## plot just Ontario
plot(cities, add=T, col="blue", pch=19, cex=2) ## plot just Toronto    
plot(torontoTransect, add=T)

## Save to file
saveRDS(torontoTransect, file = "data//transects//toronto.rds")

