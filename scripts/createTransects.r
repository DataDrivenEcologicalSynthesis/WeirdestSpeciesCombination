#### Generate Transects for Canadian cities

## Load libraries
library(raster)
library(sf)
# library(dismo) ## used to get Canada Polygon

## load fucntions
source("scripts//functions.r")

## Download polygon for Canada
# canPoly <- getData(name="GADM", country="CAN", level=1) ## run once for download
canPoly <- readRDS("data//gadm36_CAN.rds") ## load polygon
# plot(canPoly) ## takes a while because all the islands


## dataframe of lat, lon for cities
cities <- data.frame(city = c("Vancouver","Edmonton","Winnipeg","Toronto","Montreal","Halifax"),
                     lon = c(-123.1206,-113.4939,-97.1383,-79.3832,-73.5672,-63.575),
                     lat = c(49.2828,53.5461,49.895,43.6532,45.5017,44.6486))


## Create spatial dataframe
coordinates(cities) <- ~lon+lat # specify x and y columns
cities <- st_as_sf(cities) # Proceeded here with the package "sf", I find it more userfriendly than sp. Also the format with all the cities in the same dataframe class=="sf" was easier to play with than the class=="sp".
proj4string(cities) <- CRS("+proj=longlat +datum=WGS84") ## Need to use a CRS (I picked WGS84), for non-GIS folk, this does a good job explaining a CRS https://rspatial.org/raster/spatial/6-crs.html

## Notes
## a CRS of WGS84 has units in decimal degrees. The earth is circular so 1 decimal degree does not equal the same thing at different latitudes (e.g. higher latitudes smaller distances, latitudes closer to the equator are larger).
## Every degree away from the equator is equal to cosine of that latitude.
deg2rad <- function(deg) {(deg * pi) / (180)} ## function converts decimal degrees to radians
lat2km <- function(lat){ cos(deg2rad(lat)) * 111.32 } ## cosine of latitude in radius multiplied by the size of the decimal at the equator

## Find out the units of km for decimal degrees at the latitude of Toronto.
lat2km(43.6532) ## 1 decimal degree at Toronto is 80.5435

## Decimal degrees to 10 km buffer
resToronto <- 1/80.5435*10 ## 0.1241 decimal degrees  = 10 km

## List cities to generate transects not in sp dataframe
cities <- data.frame(city = c("Vancouver","Edmonton","Winnipeg","Toronto","Montreal","Halifax"),
                     lon = c(-123.1206,-113.4939,-97.1383,-79.3832,-73.5672,-63.575),
                     lat = c(49.2828,53.5461,49.895,43.6532,45.5017,44.6486))

vancouverTransect <- cityTransect(citylon = cities[cities$city == "Vancouver","lon"], citylat = cities[cities$city == "Vancouver","lat"], nquadrat = 5, buffer = 5, distance = 10)

edmontonTransect <- cityTransect(citylon = cities[cities$city == "Edmonton","lon"], citylat = cities[cities$city == "Edmonton","lat"], nquadrat = 5, buffer = 5, distance = 10)

winnipegTransect <- cityTransect(citylon = cities[cities$city == "Winnipeg","lon"], citylat = cities[cities$city == "Winnipeg","lat"], nquadrat = 5, buffer = 5, distance = 10)

torontoTransect <- cityTransect(citylon = cities[cities$city == "Toronto","lon"], citylat = cities[cities$city == "Toronto","lat"], nquadrat = 5,  ## nquadrat is the number of quadrats
                                buffer=5, ## distance in km around the centroid of city to make the buffer. e.g. 5 = 10 x 10 km box with city as center
                                distance = 10) ## distance in km between buffered transects

montrealTransect <- cityTransect(citylon = cities[cities$city == "Montreal","lon"], citylat = cities[cities$city == "Montreal","lat"], nquadrat = 5, buffer = 5, distance = 10)

halifaxTransect <- cityTransect(citylon = cities[cities$city == "Halifax","lon"], citylat = cities[cities$city == "Halifax","lat"], nquadrat = 5, buffer = 5, distance = 10)


# ## Plot to make sure it worked
# Check Vancouver
plot(canPoly[canPoly$NAME_1=="British Columbia",]) ## plot just British columbia
plot(cities, add=T, col="blue", pch=19, cex=2) ## plot all cities
plot(vancouverTransect, add = TRUE)
# Check Edmonton
plot(canPoly[canPoly$NAME_1=="Alberta",]) ## plot just Alberta
plot(cities, add=T, col="blue", pch=19, cex=2) ## plot all cities
plot(edmontonTransect, add = TRUE)
# Check Winnipeg
plot(canPoly[canPoly$NAME_1=="Manitoba",]) ## plot just Manitoba
plot(cities, add=T, col="blue", pch=19, cex=2) ## plot all cities
plot(winnipegTransect, add = TRUE)
# Check Toronto
plot(canPoly[canPoly$NAME_1=="Ontario",]) ## plot just Ontario
plot(cities, add=T, col="blue", pch=19, cex=2) ## plot all cities
plot(torontoTransect, add = TRUE)
# Check Montreal
plot(canPoly[canPoly$NAME_1=="Québec",]) ## plot just Quebec
plot(cities, add=T, col="blue", pch=19, cex=2) ## plot all cities
plot(montrealTransect, add = TRUE)
# Check Halifax
plot(canPoly[canPoly$NAME_1=="Nova Scotia",]) ## plot just Nova Scotia
plot(cities, add=T, col="blue", pch=19, cex=2) ## plot all cities
plot(halifaxTransect, add = TRUE)

## Save to file
saveRDS(vancouverTransect, file = "data/transects/vancouver.rds")
saveRDS(edmontonTransect, file = "data/transects/edmonton.rds")
saveRDS(winnipegTransect, file = "data/transects/winnipeg.rds")
saveRDS(torontoTransect, file = "data//transects//toronto.rds")
saveRDS(montrealTransect, file = "data/transects/montreal.rds")
saveRDS(halifaxTransect, file = "data/transects/halifax.rds")
