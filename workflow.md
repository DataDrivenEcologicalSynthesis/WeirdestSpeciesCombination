# workflow

`createTransects.r` generates transects for 6 canadian cities and writes out transect data to `data/transects/*.rds`

`gbifDL.r` generates `MasterSpeciesList.csv` using `data/transects/*.rds`

`MasterSpeciesList.csv` cleaned with `OpenRefine` to generate `MasterSpeciesList_clean.csv`

`matchGbifTry.R` identifies all the species from our transects that occur in the TRY database

`TRY spp. list OpenRefine` cleans ?? (`matchGbifTry.R` doesn't write out a file. Where does the file fed to Open Refine come from?) and creates `Specieslist_TRY_join.csv`

`getTRY_ids.r` takes `Specieslist_TRY_join.csv` and builds a file (`data/tryAccession/accessionMaster.csv` whose lines can be pasted into TRY

`tidying_TRYtraits.r` takes the large files obtained from TRY, reads them in, and summarizes them by mean trait value for each species. It then writes out the tidied trait values to `data/traitData.csv`

`buildSpeciesTraitData.r` takes `data/traitData.csv` from TRY and combines it with the GBIF occurrance data `MasterSpeciesList_clean.csv` to create a list of species with their associate mean trait values in `species_and_their_traits.csv`



