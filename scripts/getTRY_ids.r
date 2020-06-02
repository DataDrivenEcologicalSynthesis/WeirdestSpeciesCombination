# Match GBIF master species list with TRYspeciesList to get the access ids.

# Reading in the masterSpeciesList of each city that got cleaned in OpenRefine, and the TRYSpeciesList
MasterSpeciesList <- read.csv("data/MasterSpeciesList_clean.csv", header = TRUE, stringsAsFactors = FALSE)
TRY_SpeciesList <- read.csv("data/TRY_specieslist.csv", header = TRUE, stringsAsFactors = FALSE)

# Make one colum with Genus + Species in the TRY list
TRY_SpeciesList[,"species"] <- paste(TRY_SpeciesList$Genus, TRY_SpeciesList$Species, sep = " ")

# Only get the needed info
TRY_SpeciesList <- TRY_SpeciesList[,c("AccSpeciesID","species")]

# Drop NAs from gbif species list
MasterSpeciesList <- MasterSpeciesList[which(!is.na(MasterSpeciesList$species)),]

# Join the two file based on the species name
SpeciesList_joined <- TRY_SpeciesList[TRY_SpeciesList$species %in% MasterSpeciesList$species,]
AccSpeciesID <- unique(SpeciesList_joined[,"AccSpeciesID"]) # Get only the IDs as a vector

# Sanity check
length(AccSpeciesID) < nrow(TRY_SpeciesList)

# Separate the IDs in chunk of 1000 for the retrieval on TRYdatabase
# write out accession numbers for pasting into TRY
## TRY will only accept 1000 species codes at a time, so write out accession numbers file with lines of 1000 species codes each. Make sure to open in a text editor and not a spreadsheet program for proper copy-pasting.

if (file.exists("data/tryAccession/accessionMaster.csv")) file.remove("data/tryAccession/accessionMaster.csv") # the for loop below will just keep appending to the existing file - this line prevents duplication within the file

breaks <- seq(from=1, to=length(AccSpeciesID), by=1000)
for (i in 1:length(breaks)) {
    accessionNos <- AccSpeciesID[breaks[i]:(breaks[i] + 999)]
    write.table(t(accessionNos), "data/tryAccession/accessionMaster.csv", col.names=FALSE, row.names = FALSE, sep=",", append=TRUE)
}
