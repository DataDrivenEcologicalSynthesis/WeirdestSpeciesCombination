# what weird species are where?
# so far this script identifies the cities where Canada wide weird species occur. it also calculates the standard deviation of the SLA of Canada-wide weird species in each city and how many Canada-wide weird species a place has

library(purrr)

# get weird species at all three spatial scales
paths <- c("analysis/canada_weird.csv", "analysis/city_weird.csv", "analysis/quadrat_weird.csv")

weirdspecies <- map(paths, read.csv, header=TRUE, stringsAsFactors=FALSE)
names(weirdspecies) <- c("canada", "city", "quadrat")

# get all species and their SLA trait data
species <- read.csv("data/species_and_their_traits.csv", header=TRUE, stringsAsFactors = FALSE) %>%
    filter(TraitName == "Leaf area per leaf dry mass (specific leaf area, SLA or 1/LMA): petiole excluded") %>%
    mutate(TraitName = "SLA") # Make the trait name easier to work with

# Which Canada-wide weird species are in each city?

globalweird_in_cities <- species %>%
    filter(species %in% weirdspecies$canada$species) %>%
    group_by(City)

ggplot(globalweird_in_cities, aes(x=value, fill=City)) +
    geom_density(alpha=0.25) +
    scale_fill_viridis_d() +
    theme_bw() +
    ggtitle("Distribution of SLA", subtitle = "for Canada-wide weird species")

## Which city has the highest standard deviation in SLA for weird species, and how many weird species does it have in total?
city_sd <- globalweird_in_cities %>%
    summarize(sd = sd(value), num=n()) %>%
    arrange(desc(sd))


