## Functions for Spatial objects

## Function that create a buffer around a centroid
makePoly <- function(centroid.lon, centroid.lat, buffer){
  ## determine buffer for longitude    
  latinkm <-  lat2km(centroid.lat)
  res <- 1/latinkm*buffer
  xmin = centroid.lon - res
  xmax = centroid.lon + res
  ymin = centroid.lat - 1/111*buffer
  ymax = centroid.lat + 1/111*buffer
  cornerCoords <- matrix(c(xmin, ymin, ## South-west Corner
                           xmin, ymax, ## North-west Corner
                           xmax, ymax, ## North-East Corner
                           xmax, ymin, ## South-east Corner
                           xmin, ymin), ## South-west Corner Close
                         ncol=2, byrow=T)
  polytemp <- Polygon(cornerCoords)
  polytemp <- Polygons(list(polytemp), ID="A")
  Ps1 <- SpatialPolygons(list(polytemp), proj4string=CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"))
  return(Ps1)
}

## Create function that takes city coordinates and generated transects
cityTransect <- function(citylon, citylat, nquadrat, buffer, distance){ ## nquadrat is the number of quadrats, resolution is the km in decimal degrees, and distance is the distance between points
  distbtwbuff <- buffer*2 + distance
  disKm <- 1/111*distbtwbuff
  transect <- data.frame(lon  = seq(citylon, by = 0, length.out=nquadrat), ## keep longitude unchanged
                         lat = seq(citylat, by = disKm, length.out=nquadrat)) ## move latitude up by distance
  quadratList <- lapply(1:nquadrat, FUN=function(i){
    buff <- makePoly(transect[i,"lon"], transect[i,"lat"], buffer) ## make polygons for each position along transect
    return(buff)
  })
  return(do.call(bind, quadratList) ) ## combine polygons
}
