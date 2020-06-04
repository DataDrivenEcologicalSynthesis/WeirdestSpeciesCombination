# Generate lists of weird species by city and overall. Weird species are species with trait values in the 5th and 9th percentile.
# At this point, only considering one trait: Leaf area per leaf dry mass (specific leaf area, SLA or 1/LMA): petiole excluded

library(dplyr)
library(ggplot2)

# read in species occurance + trait data and filter for traits of interest
species_traits <- read.csv("data/species_and_their_traits.csv", header = TRUE, stringsAsFactors = FALSE)

sla <- species_traits %>%
    select(-count) %>%
    filter(TraitName == "Leaf area per leaf dry mass (specific leaf area, SLA or 1/LMA): petiole excluded") %>%
    mutate(TraitName = "SLA") # Make the trait name easier to work with))

# have a quick peek at the data
sla$City <- factor(sla$City, levels = c("Vancouver", "Edmonton", "Winnipeg", "Toronto", "Montreal", "Halifax")) # reordering city names West to East
                                        

cities <- ggplot(sla, aes(x=City, y=value, fill=as.factor(City))) +
    geom_violin() +
    theme_classic()

# fancied up a bit

cities$sla$City <- factor(cities$sla$City,
                           levels = c("Vancouver, Edmonton, Winnipeg, Toronto, Montreal, Halifax"))

cities + theme(legend.position = "none") +
    labs(x = " ",
         y = expression(paste("Specific Leaf Area (mm"^2, " ", mg^-1, sep=")")))

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

nrow(global_weird) # 158 globally weird species

# visual check - two humped?

ggplot(global_weird, aes(x=value)) +
    geom_density()

# write out globally weird
write.csv(global_weird, "analysis/canada_weird.csv", row.names = FALSE)

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

local_weird <- ggplot(local_weird, aes(x=value, fill=as.factor(City))) +
    geom_density(alpha=0.5) +
    theme_classic() 
    
## fancied it up a bit

local_weird + theme(legend.title = element_blank()) +
    labs(y = "Density",
         x = expression(paste("Specific Leaf Area (mm"^2, " ", mg^-1, sep=")"))) 


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

#####################################################################################################################
# Test section from Ben
#require(reshape2)

# I think This one is OK!
test <- sla %>%
    select(-TraitName, -quadrat) %>%
    group_by(City)
cityHist <- ggplot(test, aes(x = value, fill =  as.factor(City))) +
    facet_wrap(~ City) +
    geom_histogram(position = "stack", bins = 50) +
    ggtitle("Distribution of SLA by city, 5 quadrats confound")

cityHist + theme(legend.title = element_blank()) +
    labs(y = "Count",
         x = expression(paste("Specific Leaf Area (mm"^2, " ", mg^-1, sep=")"))) 

# Trying to make the 5 quadrat for each city (6x5 plots)
test <- sla %>%
    select(-TraitName) %>%
    group_by(City, quadrat)
#test <-  melt(test, value.name = "value")
tempDf <- data.frame(c("Edmonton","Edmonton","Winnipeg","Winnipeg"), c(3,5,4,5), c(NA,NA), c(NA,NA)) #added manualy empty rows for the missing quadrat so we have one city per columns and they are not mixed up
colnames(tempDf) <- colnames(test)
test <- rbind(test, tempDf)

allHist <- ggplot(test, aes(x = value, fill = as.factor(City))) +
    facet_wrap(quadrat ~ City) +
    geom_histogram(position = "stack", bins = 50) 
    
allHist + theme(legend.title = element_blank()) +
    labs(y = "Count",
         x = expression(paste("Specific Leaf Area (mm"^2, " ", mg^-1, sep=")"))) 
# That is legit the best i can do right now. judge me plz


# Sampling effort. Don't know if we can say this is sampling effort, but thought it was worth showing how many obs. we had per city
sampEff <- sla %>%
    group_by(City) %>%
    count()

sampEff_plot <- ggplot(sampEff, aes(x = City, y = n, fill = City)) +
    geom_bar(stat = "identity") +
    ggtitle("Number of observation per city, all species confound")

sampEff_plot + theme(legend.title = element_text("City")) +
    labs(y = "Number of observation",
         x = "City") 
