# Generate lists of weird species by city and overall. Weird species are species with trait values in the 5th and 9th percentile.
# At this point, only considering one trait: Leaf area per leaf dry mass (specific leaf area, SLA or 1/LMA): petiole excluded

library(dplyr)
library(ggplot2)

# read in species occurance + trait data and filter for traits of interest
species_traits <- read.csv("data/species_and_their_traits.csv", header = TRUE, stringsAsFactors = FALSE)

sla <- species_traits %>%
    select(-quadrat, -count) %>%
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

low <- 0.10
high <- 0.90

# GLOBALLY WEIRD
global_percentile <- quantile(sla$value, probs=c(low, high))

global_weird <- sla %>%
    select(-City) %>%
    distinct() %>%
    filter(value < global_percentile[1] | value > global_percentile[2]) %>%
    arrange(value)

nrow(global_weird) # 158 globally weird species

# visual check - two humped?

ggplot(global_weird, aes(x=value)) +
    geom_density()

# write out globally weird
write.csv("analysis/globally_weird.csv", row.names = FALSE)

# LOCALLY WEIRD

# calculate weirdness percentiles for each city
local_percentile <- sla %>%
    group_by(City) %>%
    summarise(low=quantile(value, probs=low), high=quantile(value, probs=high))

# get list of weird species in each city
local_weird <- sla %>%
    left_join(local_percentile) %>%
    filter(value < low | value > high)

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
write.csv(local_weird, "analysis/locally_weird.csv", row.names = FALSE)


