# Generate lists of weird species by city and overall. Weird species are species with trait values in the 5th and 9th percentile.
# At this point, only considering one trait: Leaf area per leaf dry mass (specific leaf area, SLA or 1/LMA): petiole excluded

library(dplyr)
library(ggplot2)

# read in species occurance + trait data and filter for traits of interest
species_traits <- read.csv("data/species_and_their_traits.csv", header = TRUE, stringsAsFactors = FALSE)

sla <- species_traits %>%
    select(-count) %>%
    filter(TraitName == "Leaf area per leaf dry mass (specific leaf area, SLA or 1/LMA): petiole excluded") %>%
    mutate(TraitName = "SLA") # Make the trait name easier to work with

# have a quick peek at the data

ggplot(sla, aes(x=City, y=value, fill=as.factor(City))) +
    geom_violin()

# calculate percentiles

# pick low and high percentiles

lowp <- 0.10
highp <- 0.90

# GLOBALLY WEIRD
global_percentile <- quantile(sla$value, probs=c(lowp, highp))

global_weird <- sla %>%
    select(-City, -quadrat) %>%
    distinct() %>%
    filter(value < global_percentile[1] | value > global_percentile[2]) %>%
    arrange(value)

nrow(global_weird) # 84 globally weird species

# visual check - two humped?

ggplot(global_weird, aes(x=value)) +
    geom_density()

# write out globally weird
write.csv("analysis/globally_weird.csv", row.names = FALSE)

# LOCALLY WEIRD

# calculate weirdness percentiles for each city
local_percentile <- sla %>%
    select(-quadrat) %>%
    group_by(City) %>%
    summarise(low=quantile(value, probs=lowp), high=quantile(value, probs=highp))

# get list of weird species in each city
local_weird <- sla %>%
    left_join(local_percentile) %>%
    filter(value < low | value > high) %>%
    select(-low, -high)

# counts of weird
local_weird %>%
    group_by(City) %>%
    summarise(weird=n())

# City      weird
# <chr>     <int>
#1 Edmonton     34
# 2 Halifax      72
# 3 Montreal    103
# 4 Toronto     109
# 5 Vancouver   102
# 6 Winnipeg     24

# visual check - two humped?
ggplot(local_weird, aes(x=value, fill=as.factor(City))) +
    geom_density(alpha=0.5)

# write out locally weird
write.csv(local_weird, "analysis/city_weird.csv", row.names = FALSE)

# HYPERLOCALLY WEIRD (quadrat)

hyperlocal_percentile <- sla %>%
    group_by(City, quadrat) %>%
    summarise(low=quantile(value, probs=lowp), high=quantile(value, probs=highp))

# get list of weird species in each quadrat
hyperlocal_weird <- sla %>%
    left_join(hyperlocal_percentile) %>%
    filter(value < low | value > high) %>%
    select(-low, -high)

# visual check - two humped?
ggplot(local_weird, aes(x=value, fill=as.factor(City))) +
    geom_density(alpha=0.5) +
    facet_wrap("quadrat")

# write out hyperlocally weird
write.csv(hyperlocal_weird, "analysis/quadrat_weird.csv", row.names = FALSE)


