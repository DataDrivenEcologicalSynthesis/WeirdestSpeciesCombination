library(dplyr)
library(purrr)

species <- read.csv("data/MasterSpeciesList_clean.csv", header=TRUE, stringsAsFactors = FALSE) %>%
    filter(!is.na(species))

bycity <- species %>%
    split(.$City) %>%
    map(select, species)

#all cities
inallcities <- Reduce(intersect, bycity) #species that occur in all cities - the most common city community. 55 species total

# what % of the total species in a city is in the most common species list
species %>%
    select(-quadrat) %>%
    distinct() %>%
    group_by(City) %>%
    summarize(percent_common = (nrow(inallcities)/n())*100) %>%
    arrange(desc(percent_common))

# Percent of a city's species that are in the set of species that occur in all cities
# City      percent_common
# <chr>              <dbl>
# 1 Winnipeg           16.4
# 2 Edmonton            9.15
# 3 Halifax             5.11
# 4 Toronto             4.31
# 5 Montreal            3.56
# 6 Vancouver           2.10


# all species that occur in more than one quadrat
morethan1 <- species %>%
    group_by(species) %>%
    summarize(count=n()) %>% # how many quadrats does a species occur in
    filter(count > 1)

