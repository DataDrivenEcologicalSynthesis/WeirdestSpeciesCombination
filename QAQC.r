## QAQC

## Function to load csv and attach filename too
addCSV <- function(x) { 
  out <- read.csv(x)
  filename <- gsub(".csv", "", basename(x))
  out[,"source"] <- filename
  return(out)
  }

## Load transect data
transectfiles <- list.files("data//gbif//", pattern=".csv", full.names = T)
transectfiles <- transectfiles[-7]
allData <- do.call(rbind, lapply(transectfiles, addCSV))
allData$source <- gsub('_.*','',allData$source)


allData %>% group_by(source, quadrat) %>% summarize(rich = length(unique(scientificName))) %>%  data.frame(.)