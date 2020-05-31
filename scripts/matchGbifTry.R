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


# TORONTO ONLY ANALYSIS SO FAR BELOW THIS LINE - needs to be extended to multiple cities

# get list of accession numbers to paste into TRY https://www.try-db.org/TryWeb/Prop2.php
overlap <- trySpecies[trySpecies$scientificName %in% torSpecies$scientificName,] # TRY species in Toronto species list

# write out accession numbers for pasting into TRY
## TRY will only accept 1000 species codes at a time, so write out accession numbers file with lines of 1000 species codes each. Make sure to open in a text editor and not a spreadsheet program for proper copy-pasting.

breaks <- seq(from=1, to=nrow(overlap), by=1000)
if (file.exists("data/tryAccession/accessionNos.csv")) file.remove("data/tryAccession/accessionNos.csv") # the for loop below will just keep appending to the existing file - this line prevents duplication within the file

for (i in 1:length(breaks)) {
    accessionNos <- overlap$AccSpeciesID[breaks[i]:(breaks[i] + 999)]
    write.table(t(accessionNos), "data/tryAccession/accessionNos.csv", col.names=FALSE, row.names = FALSE, sep=",", append=TRUE)
}

# Proportion of Toronto species NOT included in TRY
(nrow(torSpecies) - nrow(overlap))/nrow(torSpecies) # ~47%

