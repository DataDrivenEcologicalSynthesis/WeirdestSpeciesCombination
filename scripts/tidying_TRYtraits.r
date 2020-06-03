require(data.table)
require(tidyverse)

# Unzip the files (The TRY .zip files should be the only .zip files in the folder)
TRYzip <- list.files(pattern = ".*zip") %>%
as.list(.) %>%
lapply(TRYzip, function(x) unzip(x, overwrite = TRUE, exdir = "."))

# Read the files (The TRY trait files should be the only .txt files in the folder)
TRYfiles <- list.files(pattern = ".*txt") %>% # Getting the name of each .txt file
as.list(.) %>% # Putting them into a list
lapply(., function(x) fread(x, header = TRUE, sep = "\t", dec = ".", quote = "", data.table = TRUE)) %>% # Reading each element of the list into a data.table
rbindlist(.) %>% # Rbinding all the files together
.[,c("SpeciesName","AccSpeciesID","AccSpeciesName","TraitName","OrigValueStr","OrigUnitStr","ValueKindName","StdValue","UnitName")] # Get only the necessary column (That was a quick check)


############################################################################################################
# Part where we need to separate the huge data.table into multiple .csv file              
# I used data.table because I believe it's the fastest way of manipulating HUGE files (?)
# Too tired and can't find a way to properly divide the data.table, going to let what i tried there as a draft/idea on how to do it

# Breaking the file into a list based on TraitName. Not really sure it's going to work tomorrow with ALL the 5 trait file because too big, but i cant think of anything else right now
TRYfiles <- split(TRYfiles, by ="TraitName") # Split the file into a list by the variable "TraitName", so length(list) == 17 since there are 17 traits
names(TRYfiles) <- paste0("trait_", c(1:length(test))) # We don't really care about the trait name in the file name so i winnowed them
lapply(TRYfiles, function(x) fwrite(TRYfiles, file = "test.csv", row.names = FALSE, col.names = TRUE))
fwrite(TRYfiles, file = "test.csv", row.names = FALSE, col.names = TRUE)
