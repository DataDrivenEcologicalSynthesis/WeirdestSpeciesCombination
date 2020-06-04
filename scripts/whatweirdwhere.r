# what weird species are where?
# so far this script identifies the cities where Canada wide weird species occur. it also calculates the standard deviation of the SLA of Canada-wide weird species in each city and how many Canada-wide weird species a place has

library(purrr)

# get weird species at all three spatial scales
paths <- c("analysis/canada_weird.csv", "analysis/city_weird.csv", "analysis/quadrat_weird.csv")

weirdspecies <- map(paths, read.csv, header=TRUE, stringsAsFactors=FALSE)
names(weirdspecies) <- c("canada", "city", "quadrat")


weirdspecies$city$City <- factor(weirdspecies$city$City, levels = c("Vancouver", "Edmonton", "Winnipeg", "Toronto", "Montreal", "Halifax"))

# get all species and their SLA trait data
species <- read.csv("data/species_and_their_traits.csv", header=TRUE, stringsAsFactors = FALSE) %>%
    filter(TraitName == "Leaf area per leaf dry mass (specific leaf area, SLA or 1/LMA): petiole excluded") %>%
    mutate(TraitName = "SLA") # Make the trait name easier to work with

species$City <- factor(species$City, levels = c("Vancouver", "Edmonton", "Winnipeg", "Toronto", "Montreal", "Halifax"))

# Which Canada-wide weird species are in each city?

globalweird_in_cities <- species %>%
    filter(species %in% weirdspecies$canada$species) %>%
    group_by(City)

globalweird <- ggplot(globalweird_in_cities, aes(x=value, fill=City)) +
    geom_density() +
    theme_bw() +
    ggtitle("Distribution of SLA", subtitle = "for Canada-wide weird species") +
    facet_wrap("City")

ggsave("figures/weird_slas_by_city.png", globalweird, width=8, height=9, units="in")

## Which city has the highest standard deviation in SLA for weird species, and how many weird species does it have in total?
city_sd <- globalweird_in_cities %>%
    summarize(sd = sd(value), num=n()) %>%
    arrange(desc(sd))

# Which city-wide species are in each quadrat
quadrat_sd <- weirdspecies$city %>%
    group_by(City, quadrat) %>%
    summarize(sd=sd(value), num=n()) %>%
    arrange(desc(sd))

# Top 5 weirdest quadrats
# # Groups:   City [6]
# City      quadrat    sd   num
# <chr>       <int> <dbl> <int>
# 1 Halifax         3  24.7     3
# 2 Halifax         4  24.2     3
# 3 Vancouver       1  23.9    83
# 4 Montreal        1  22.8    77
# 5 Vancouver       3  22.6     4

# Plot of the "weird" species traits in each city and quadrat
weirdslaquadratcity <- ggplot(weirdspecies$city, aes(x=value, fill=City)) +
    geom_density(alpha=0.5) +
    facet_grid(factor(quadrat, levels = c("5", "4", "3", "2", "1")) ~ .) +
    theme_classic(base_size = 18) +
    theme(legend.position = "bottom", axis.text.y=element_blank() ) +
    labs(x="SLA")


ggsave("figures/weird_slas_by_city_and_quad.png", weirdslaquadratcity, width=8, height=9, units="in")

