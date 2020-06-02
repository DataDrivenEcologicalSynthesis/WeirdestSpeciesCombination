# Match GBIF master species list with TRYspeciesList to get the access ids.

# Reading in the masterSpeciesList of each city that got cleaned in OpenRefine, and the TRYSpeciesList
MasterSpeciesList <- read.csv("data/MasterSpeciesList_clean.csv", header = TRUE, stringsAsFactors = FALSE)
TRY_SpeciesList <- read.csv("data/TRY_specieslist.csv", header = TRUE, stringsAsFactors = FALSE)

# Drop NAs from gbif species list
MasterSpeciesList <- MasterSpeciesList[which(!is.na(MasterSpeciesList$species)),]

# Join the two file based on the species name
SpeciesList_joined <- TRY_SpeciesList[TRY_SpeciesList$species %in% MasterSpeciesList$species,]



