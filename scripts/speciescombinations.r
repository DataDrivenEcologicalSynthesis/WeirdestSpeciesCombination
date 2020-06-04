library(dplyr)
library(purrr)

species <- read.csv("data/MasterSpeciesList_clean.csv", header=TRUE, stringsAsFactors = FALSE) %>%
    filter(!is.na(species))

bycity <- species %>%
    split(.$City) %>%
    map(select, species)

#all cities
inallcities <- Reduce(intersect, bycity) #species that occur in all cities - the most common city community
#
# > inallcities
# species
# 1             Acer negundo
# 2     Achillea millefolium
# 3  Ambrosia artemisiifolia
# 4            Arctium minus
# 5        Calystegia sepium
# 6  Campanula rapunculoides
# 7  Capsella bursa-pastoris
# 8          Cirsium arvense
# 9     Convolvulus arvensis
# 10       Cornus canadensis
# 11          Cornus sericea
# 12         Corylus cornuta
# 13    Eleocharis palustris
# 14       Equisetum arvense
# 15     Erigeron canadensis
# 16   Euphorbia cyparissias
# 17   Euthamia graminifolia
# 18      Glechoma hederacea
# 19       Helianthus annuus
# 20     Hesperis matronalis
# 21         Hordeum jubatum
# 22         Humulus lupulus
# 23    Leucanthemum vulgare
# 24        Linaria vulgaris
# 25        Linnaea borealis
# 26      Lotus corniculatus
# 27       Lythrum salicaria
# 28   Maianthemum stellatum
# 29    Matricaria discoidea
# 30       Medicago lupulina
# 31         Medicago sativa
# 32         Melilotus albus
# 33   Melilotus officinalis
# 34       Panicum capillare
# 35    Phalaris arundinacea
# 36          Plantago major
# 37     Polygonum aviculare
# 38     Populus tremuloides
# 39      Portulaca oleracea
# 40         Prunus serotina
# 41       Rorippa palustris
# 42         Rudbeckia hirta
# 43       Sambucus racemosa
# 44        Senecio vulgaris
# 45        Sinapis arvensis
# 46   Sisymbrium altissimum
# 47     Solidago canadensis
# 48        Sonchus arvensis
# 49    Symphoricarpos albus
# 50       Tanacetum vulgare
# 51    Taraxacum officinale
# 52      Trifolium hybridum
# 53        Trifolium repens
# 54         Viburnum opulus
# 55            Vicia cracca

# what % of the total species in a city is the most common species list
percent_common <- species %>%
    select(-quadrat) %>%
    distinct() %>%
    group_by(City) %>%
    summarize(percent_common = (nrow(inallcities)/n())*100) %>%
    arrange(desc(percent_common))

vulgar <- ggplot(percent_common, aes(x=City, y=percent_common, fill=City)) +
    geom_col() +
    labs(x="", y="Vulgarity index") +
    ylim(c(0,100)) +
    theme_classic(base_size=18) +
    theme(legend.position = "none")

ggsave("figures/city_vulgarity.png", vulgar, width = 16, height=9, units="in")

# all species that occur in more than one quadrat
morethan1 <- species %>%
    group_by(species) %>%
    summarize(count=n()) %>% # how many quadrats does a species occur in
    filter(count > 1)

