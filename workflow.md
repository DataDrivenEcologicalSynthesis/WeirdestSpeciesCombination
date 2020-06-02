# workflow

`createTransects.r` generates transects for 6 canadian cities and writes out transect data to `data/transects/*.rds`

`gbifDL.r` generates `MasterSpeciesList.csv` using `data/transects/*.rds`

`MasterSpeciesList.csv` cleaned with `OpenRefine` to generate `MasterSpeciesList_clean.csv`

`matchGbifTry.R` identifies all the species from our transects that occur in the TRY database

`TRY spp. list OpenRefine` cleans ?? (`matchGbifTry.R` doesn't write out a file. Where does the file fed to Open Refine come from?) and creates `Specieslist_TRY_join.csv`

`getTRY_ids.r` takes `Specieslist_TRY_join.csv` and builds a file (`data/tryAccession/accessionMaster.csv` whose lines can be pasted into TRY




