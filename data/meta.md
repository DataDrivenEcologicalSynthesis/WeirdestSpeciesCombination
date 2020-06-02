# meta

- `TRY_specieslist.csv` all the species in TRY

- `tryTraitListFull.csv` list of all traits in TRY database, the id TRY uses to identify them, the number of records with those traits recorded, and two columns of mystery numbers

- `tryTraitsSelection.csv` traits selected for download from TRY with TRY id numbers

- `MasterSpeciesList.csv` all the species present in all of the quadrats and cities

- `MasterSpeciesList_clean.csv` master species list cleaned of misspellings/out of date taxonomy using OpenRefine script `Open Refine Fix Spp. names` in the scripts folder

- `Specieslist_TRY_join.csv` is the list with species names and TRY codes with duplicates removed. The "SpeciesList_joined" created by `getTRY_ids.r`, which joins the `MasterSpeciesList_clean.csv` and the `TRY_specieslist.csv`, is brought into OpenRefine where we run the `Remove duplicates OpenRefine` script to remove duplicate species names. There are 3190 observations.

- `AccessionMaster_correct.csv` contains the codes, broken into 1000 codes per row, generated using `Specieslist_TRY_join.csv`. 

TRY request
- used `AccessionMaster_correct.csv` for the species codes
- used `tryTraitsSelection.csv` to request the traits (20 total)
- Only requested publically available traits:
  * Pull 1: 201461 total trait measurements, 179594 of which are public.
  * Pull 2: 174699 total trait measurements, 156453 of which are public.
  * Pull 3: 236685 total trait measurements, 206541 of which are public.
  * Pull 4: 48192 total trait measurements, 43547 of which are public.
  * Pulls 1 - 3 were 1000 species, pull 4 was 190 species


