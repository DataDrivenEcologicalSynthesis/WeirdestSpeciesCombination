# join TRY trait data with quadrat occurrence data so we know

library(dplyr)

# Read in the trait data from TRY and the species data from GBIF
traits <-read.csv("data/traitData.csv", header=TRUE, stringsAsFactors = FALSE)
species <- read.csv("data/MasterSpeciesList_clean.csv", header=TRUE, stringsAsFactors = FALSE)

# Join the trait and species occurrance data
species_traits <- left_join(species, traits, by = c("species" = "SpeciesName")) %>%
    filter(!is.na(TraitName) & !is.na(value)) # Dropping species that don't have any trait data or have NA trait data. 5 of the traits are removed entirely because we selected some discrete traits.

nrow(species_traits) # We have 17654 species-trait combinations

# Later we might want to consider how dropping NAs biases our results. Vancouver has a lot of species with no traits.
no_traits <- left_join(species, traits, by = c("species" = "SpeciesName")) %>%
    filter(is.na(TraitName) | !is.na(value)) %>%
    group_by(City) %>%
    summarize(no_trait_species = n())
# City      no_trait_species
# <chr>                <int>
# 1 Edmonton              1575
# 2 Halifax               3311
# 3 Montreal              4595
# 4 Toronto               4795
# 5 Vancouver             5352
# 6 Winnipeg              1120

# Write out combined species and trait data
write.csv(species_traits, "data/species_and_their_traits.csv", row.names = FALSE)
