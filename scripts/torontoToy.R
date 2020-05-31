# Create toy version of analysis using just Toronto
library(taxize)
library(tidyverse)

# grab species list created with gbifDL.r
vanSpecies <- read.csv("data/VancouverSpeciesList.csv")
edmSpecies <- read.csv("data/EdmontonSpeciesList.csv")
winSpecies <- read.csv("data/WinnipegSpeciesList.csv")
torSepcies <- read.csv("data/TorontoSpeciesList.csv")
mtlSpecies <- read.csv("data/MontrealSpeciesList.csv")
halSpecies <- read.csv("data/HalifaxSpeciesList.csv")

# grab list of all the species in TRY
trySpecies <- read.csv("data/TRY_specieslist.csv") %>%
    unite("scientificName", Genus, Species, sep=" ") # genus and species are separate columns in try data, one in the gbif species list

# Which species in our quadrats are in the TRY database?

# scientific names from gbif contain the authority, but in try they do not.
unique(speciesList$scientificName)[1:100]
trySpecies$scientificName[1:100]

# TODO strip authority from gbif
vanSpecies[, "scientificName"] <- gbif_parse(vanSpecies$scientificName)[, "canonicalname"]
edmSpecies[, "scientificName"] <- gbif_parse(edmSpecies$scientificName)[, "canonicalname"]
winSpecies[, "scientificName"] <- gbif_parse(winSpecies$scientificName)[, "canonicalname"]
torSpecies[, "scientificName"] <- gbif_parse(torSpecies$scientificName)[, "canonicalname"]
mtlSpecies[, "scientificName"] <- gbif_parse(mtlSpecies$scientificName)[, "canonicalname"]
halSpecies[, "scientificName"] <- gbif_parse(halSpecies$scientificName)[, "canonicalname"]


# get list of accession numbers to paste into TRY https://www.try-db.org/TryWeb/Prop2.php

trySpecies[trySpecies$scientificName %in% speciesList$scientificName,]$AccSpeciesID


