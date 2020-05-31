# Create toy version of analysis using just Toronto
library(taxize)
library(tidyverse)

# grab species list created with gbifDL.r
vanSpecies <- read.csv("data/VancouverSpeciesList.csv")
edmSpecies <- read.csv("data/EdmontonSpeciesList.csv")
winSpecies <- read.csv("data/WinnipegSpeciesList.csv")
torSpecies <- read.csv("data/TorontoSpeciesList.csv")
mtlSpecies <- read.csv("data/MontrealSpeciesList.csv")
halSpecies <- read.csv("data/HalifaxSpeciesList.csv")

# grab list of all the species in TRY
trySpecies <- read.csv("data/TRY_specieslist.csv") %>%
    unite("scientificName", Genus, Species, sep=" ") # put genus and species in one column

# Which species in our quadrats are in the TRY database?

# scientific names from gbif contain the authority, but in TRY they do not.
unique(speciesList$scientificName)[1:10]
trySpecies$scientificName[1:10]

# strip authority from gbif
vanSpecies[, "scientificName"] <- gbif_parse(vanSpecies$scientificName)[, "canonicalname"]
edmSpecies[, "scientificName"] <- gbif_parse(edmSpecies$scientificName)[, "canonicalname"]
winSpecies[, "scientificName"] <- gbif_parse(winSpecies$scientificName)[, "canonicalname"]
torSpecies[, "scientificName"] <- gbif_parse(torSpecies$scientificName)[, "canonicalname"]
mtlSpecies[, "scientificName"] <- gbif_parse(mtlSpecies$scientificName)[, "canonicalname"]
halSpecies[, "scientificName"] <- gbif_parse(halSpecies$scientificName)[, "canonicalname"]


# get list of accession numbers to paste into TRY https://www.try-db.org/TryWeb/Prop2.php

torOverlap <- trySpecies[trySpecies$scientificName %in% torSpecies$scientificName,] # TRY species in Toronto species list

write.table(x=torOverlap$AccSpeciesID, "data/tryAccession/tor_accession.csv", row.names = FALSE, col.names = FALSE, sep=",")

# Proportion of Toronto species NOT included in TRY
(nrow(torSpecies) - nrow(torOverlap))/nrow(torSpecies) # ~47%

