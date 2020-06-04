library(dplyr)
library(ggplot2)
library(ggbeeswarm)
library(gridExtra)

species_traits <- read.csv("data/species_and_their_traits.csv", header = TRUE, stringsAsFactors = FALSE)

unique(species_traits$TraitName)
unique(species_traits$quadrat)

species_traits %>%
    group_by(TraitName) %>%
    summarize(n())

SLA <- species_traits %>%
    filter(TraitName=="Leaf area per leaf dry mass (specific leaf area, SLA or 1/LMA): petiole excluded")

unique(SLA)
write.csv(SLA, "SLA_data.csv")

# boxplots of species traits by city
ggplot(species_traits, aes(x=value, fill=as.factor(City))) +
    facet_wrap(. ~ TraitName, scales="free_x") +
    geom_boxplot()


meansd <- species_traits %>%
    group_by(City, quadrat, TraitName) %>%
    summarise(sd = sd(value))

### boxplots of SLA

SLA_boxplot <- ggplot(SLA, aes(x=value, fill=as.factor(City))) +
    facet_wrap(. ~ TraitName, scales="free_x") +
    geom_boxplot() +
    theme_classic()

SLA_boxplot

### Cities 

colnames(SLA)

# Edmonton YEG

SLA_YEG <- SLA %>% 
    filter(City == "Edmonton")

unique(SLA_YEG$quadrat) # 1, 2, 4

YEG <- ggplot(SLA_YEG, aes(x = as.factor(quadrat), y = value))

YEGS <- YEG + geom_boxplot() +
    theme_classic()

# Halifax YHZ

SLA_YHZ <- SLA %>% 
    filter(City == "Halifax")

unique(SLA_YHZ$quadrat) # 1, 2, 3, 4, 5

YHZ <- ggplot(SLA_YHZ, aes(x = as.factor(quadrat), y = value))

YHZS <-YHZ + geom_boxplot() +
    theme_classic()

# Vancouver YVR

SLA_YVR <- SLA %>% 
    filter(City == "Vancouver")

unique(SLA_YVR$quadrat) # 1, 2, 3, 4, 5

YVR <- ggplot(SLA_YVR, aes(x = as.factor(quadrat), y = value))

YVRS <- YVR + geom_boxplot() +
    theme_classic()


# Winnipeg  YWG
SLA_YWG <- SLA %>% 
    filter(City == "Winnipeg")

unique(SLA_YWG$quadrat) # 1, 2, 3

YWG <- ggplot(SLA_YWG, aes(x = as.factor(quadrat), y = value))

YWGS <- YWG + geom_boxplot() +
    theme_classic()

# Toronto YYZ

SLA_YYZ <- SLA %>% 
    filter(City == "Toronto")

unique(SLA_YYZ$quadrat) # 1, 2, 3, 4, 5

YYZ <- ggplot(SLA_YYZ, aes(x = as.factor(quadrat), y = value))

YYZS <- YYZ + geom_boxplot() +
    theme_classic()

# Montreal YUL

SLA_YUL <- SLA %>% 
    filter(City == "Montreal")

unique(SLA_YUL$quadrat) # 1, 2, 3, 4, 5

YUL <- ggplot(SLA_YUL, aes(x = as.factor(quadrat), y = value))

YULS <- YUL + geom_boxplot() +
    theme_classic()

grid.arrange(YVRS, YEGS, YWGS, YYZS, YULS, YHZS, nrow = 6)
