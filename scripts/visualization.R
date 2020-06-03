library(dplyr)
library(ggplot2)
library(ggbeeswarm)

species_traits <- read.csv("data/species_and_their_traits.csv", header = TRUE, stringsAsFactors = FALSE)

unique(species_traits$TraitName)

species_traits %>%
    group_by(TraitName) %>%
    summarize(n())

species_traits %>%
    filter(TraitName=="Leaf area per leaf dry mass (specific leaf area, SLA or 1/LMA): petiole excluded")

# boxplots of species traits by city
ggplot(species_traits, aes(x=value, fill=as.factor(City))) +
    facet_wrap(. ~ TraitName, scales="free_x") +
    geom_boxplot()


meansd <- species_traits %>%
    group_by(City, quadrat, TraitName) %>%
    summarise(sd = sd(value))

