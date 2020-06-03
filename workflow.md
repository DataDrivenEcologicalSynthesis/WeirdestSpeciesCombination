# workflow

`createTransects.r` generates transects for 6 canadian cities and writes out transect data to `data/transects/*.rds`

`gbifDL.r` generates `MasterSpeciesList.csv` using `data/transects/*.rds`

`MasterSpeciesList.csv` cleaned with `OpenRefine` to generate `MasterSpeciesList_clean.csv`

`matchGbifTry.R` identifies all the species from our transects that occur in the TRY database

`getTRY_ids.r` combines all of the species and the TRY AccCodes (output is `Specieslist_joined`) but there are lots of duplicate species because of subsp. and var. 

The output of the species lists & TRY codes, with duplicates (`Specieslist_Joined`) is then brought into OpenRefine where`TRY spp. list OpenRefine` removes all duplicate values and creates `Specieslist_TRY_join.csv`

`getTRY_ids.r` takes `Specieslist_TRY_join.csv` and builds a file (`data/tryAccession/accessionMaster.csv`) where each row represents 1000 species (3) and one represents 190 species. Each row needs to be converted into the TRY format which is a list separated by commas.
  * Easy way to do this is to take it into word (copy & paste text) and find replace "   " with ", " 
  * Copy and paste the word file into TRY

`tidying_TRYtraits.r` takes the large files obtained from TRY, reads them in, and summarizes them by mean trait value for each species. It then writes out the tidied trait values to `data/traitData.csv`

`buildSpeciesTraitData.r` takes `data/traitData.csv` from TRY and combines it with the GBIF occurrance data `MasterSpeciesList_clean.csv` to create a list of species with their associate mean trait values in `species_and_their_traits.csv`



