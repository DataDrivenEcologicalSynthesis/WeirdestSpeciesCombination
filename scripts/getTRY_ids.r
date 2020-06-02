# create a file of TRY accession numbers to obtain data from the TRY database

TRY_SpeciesList <- read.csv("data/Specieslist_TRY_join.csv", header=TRUE, stringsAsFactors = FALSE)
AccSpeciesID <- unique(TRY_SpeciesList[,"AccSpeciesID"]) # Get only the IDs as a vector

# Separate the IDs in chunk of 1000 for the retrieval on TRYdatabase
# write out accession numbers for pasting into TRY
## TRY will only accept 1000 species codes at a time, so write out accession numbers file with lines of 1000 species codes each. Make sure to open in a text editor and not a spreadsheet program for proper copy-pasting.

if (file.exists("data/tryAccession/accessionMaster.csv")) file.remove("data/tryAccession/accessionMaster.csv") # the for loop below will just keep appending to the existing file - this line prevents duplication within the file

breaks <- seq(from=1, to=length(AccSpeciesID), by=1000)
for (i in 1:length(breaks)) {
    accessionNos <- AccSpeciesID[breaks[i]:(breaks[i] + 999)]
    write.table(t(accessionNos), "data/tryAccession/accessionMaster.csv", col.names=FALSE, row.names = FALSE, sep=",", append=TRUE)
}
