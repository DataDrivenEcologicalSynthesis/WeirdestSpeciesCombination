# Script to winnow down the species to 11 occurence min and then matching with TRYspeciesList to get the accessNumbers.
library(dplyr)
# Reading in the masterSpeciesList of each city that got cleaned in OpenRefine, and the TRYSpeciesList
MasterSpeciesList <- read.csv("data/MasterSpeciesList_clean.csv", header = TRUE, stringsAsFactors = FALSE)
TRY_SpeciesList <- read.csv("data/TRY_specieslist.csv", header = TRUE, stringsAsFactors = FALSE)

# Make one colum with Genus + Species in the TRY list
TRY_SpeciesList[,"species"] <- paste(TRY_SpeciesList$Genus, TRY_SpeciesList$Species, sep = " ")

# Onyl get the needed info
TRY_SpeciesList <- TRY_SpeciesList[,c("AccSpeciesID","species")]

# Join the two file based on the species name
SpeciesList_joined <- dplyr::left_join(MasterSpeciesList, TRY_SpeciesList, by = "species")
SpeciesList_joined <- unique(SpeciesList_joined[,c("species", "AccSpeciesID")]) # Get only the names and the TRY IDs
SpeciesList_joined <- SpeciesList_joined[which(!is.na(SpeciesList_joined$AccSpeciesID)),] # Remove the row that has ID = NA
AccSpeciesID <- SpeciesList_joined[,"AccSpeciesID"] # Get only the IDs as a vector

# Separate the IDs in chunck of 1000 for the retrieval on TRYdatabase
# (Susannah's code)
# write out accession numbers for pasting into TRY
## TRY will only accept 1000 species codes at a time, so write out accession numbers file with lines of 1000 species codes each. Make sure to open in a text editor and not a spreadsheet program for proper copy-pasting.

breaks <- seq(from=1, to=length(AccSpeciesID), by=1000)
if (file.exists("data/tryAccession/accessionMaster.csv")) file.remove("data/tryAccession/accessionMaster.csv") # the for loop below will just keep appending to the existing file - this line prevents duplication within the file

for (i in 1:length(breaks)) {
    accessionNos <- AccSpeciesID[breaks[i]:(breaks[i] + 999)]
    write.table(t(accessionNos), "data/tryAccession/accessionMaster.csv", col.names=FALSE, row.names = FALSE, sep=",", append=TRUE)
}