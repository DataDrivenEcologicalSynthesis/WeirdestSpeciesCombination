library(dplyr)
library(purrr)

species <- read.csv("data/MasterSpeciesList_clean.csv", header=TRUE, stringsAsFactors = FALSE) %>%
    filter(!is.na(species))

bycity <- species %>%
    split(.$City) %>%
    map(select, species)

#all cities
inallcities <- Reduce(intersect, bycity) #species that occur in all cities - the most common city community

# what % of the total species in a city is the most common species list
species %>%
    select(-quadrat) %>%
    distinct() %>%
    group_by(City) %>%
    summarize(percent_common = (nrow(inallcities)/n())*100) %>%
    arrange(desc(percent_common))


# all species that occur in more than one quadrat
morethan1 <- species %>%
    group_by(species) %>%
    summarize(count=n()) %>% # how many quadrats does a species occur in
    filter(count > 1)

