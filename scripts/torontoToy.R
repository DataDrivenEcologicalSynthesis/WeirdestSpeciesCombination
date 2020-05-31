# Create toy version of analysis using just Toronto

library(tidyverse)
# grab species list created with gbifDL.r
speciesList <- read.csv("data/TorontoSpeciesList.csv")
# grab list of all the species in TRY
trySpecies <- read.csv("data/TRY_specieslist.csv") %>%
    unite("scientificName", Genus, Species, sep=" ") # genus and species are separate columns in try data, one in the gbif species list

# Which species in our quadrats are in the TRY database?

# scientific names from gbif contain the authority, but in try they do not.
unique(speciesList$scientificName)[1:100]
trySpecies$scientificName[1:100]

# TODO strip authority from gbif



# get list of accession numbers to paste into TRY https://www.try-db.org/TryWeb/Prop2.php

trySpecies[trySpecies$scientificName %in% speciesList$scientificName,]$AccSpeciesID


