# weird extremes
library(purrr)

weirdfiles <- paste0("analysis/", list.files("analysis/", pattern = "*.csv"))

weirdlist <- map(weirdfiles, read.csv, header=TRUE, stringsAsFactors=FALSE)

canada <- weirdlist[[1]] %>%
    summarise(min = min(value), max=max(value))

city <- weirdlist[[2]] %>%
    group_by(City) %>%
    summarise(min = min(value), max=max(value))

species_traits <- read.csv("data/species_and_their_traits.csv", header=TRUE, stringsAsFactors = FALSE)

sla <- species_traits %>%
    select(-count) %>%
    filter(TraitName == "Leaf area per leaf dry mass (specific leaf area, SLA or 1/LMA): petiole excluded") %>%
    mutate(TraitName = "SLA") # Make the trait name easier to work with))


extreme_species_quad <- sla %>%
    group_by(City, quadrat) %>%
    filter(value == min(value) | value==max(value)) %>%
    arrange(City, quadrat, value)

extreme_species_city <- sla %>%
    group_by(City) %>%
    filter(value == min(value) | value==max(value)) %>%
    arrange(City, value)

extreme <- sla %>%
    filter(value == min(value) | value==max(value)) %>%
    arrange(value)
