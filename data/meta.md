# meta

- `TRY_specieslist.csv` all the species in TRY

- `tryTraitListFull.csv` list of all traits in TRY database, the id TRY uses to identify them, the number of records with those traits recorded, and two columns of mystery numbers

- `tryTraitsSelection.csv` traits selected for download from TRY with TRY id numbers

- `MasterSpeciesList.csv` all the species present in all of the quadrats and cities

- `MasterSpeciesList_clean.csv` master species list cleaned of misspellings/out of date taxonomy using OpenRefine script `Open Refine Fix Spp. names` in the scripts folder

- `Specieslist_TRY_join.csv` output from joining the `MasterSpeciesList_clean.csv` and the `TRY_specieslist.csv`, removed all the duplicate names using the OpenRefine script `Remove duplicates OpenRefine` in the scripts folder
