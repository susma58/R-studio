# Project name:

# Air quality and mortality trends in chicago
# Goal: explore pollution levels, temperature and their possible relationship
# with mortality using dplyr functions
# 
# Build and share below details:
# - Monthly average PM2.5
# - Top 5 worst pollution days
# - Average PM2.5 by weekday
# - Create PM2.5 Category (Good, Moderate, Unhealthy)
# - Aggregated overview for each category
# - Count number of days in each PM2.5 category

# Data manipulation; piping; summarizing data and joining dataframes (dplyr) and pivoting (tidyr )
# select, filter, arrange, summarise, mutate, group_by
# install.packages('tidyverse')
library(tidyverse)


library(tidyverse)
# install.packages('palmerpenguins')
library(palmerpenguins)

filter(penguins, species == 'Gentoo')


# retun gentoo or chinstrap
filter(penguins, species == 'Gentoo' | species == 'Chinstrap')
filter(penguins, species %in% c('Gentoo', 'Chinstrap'))

# return only female gentoos
filter(penguins, species == 'Gentoo' & sex == 'female')


install.packages('readxl')
library(readxl)


# simulated fertilizer trial
fert_data <- tibble(
  PlotID = 1:12,
  Variety = rep(c('A', 'B', 'C'), each = 4), 
  Treatment = rep(c('Control', 'Urea', 'Compost','NPK'), 3),
  Yield_kg = c(2.5, 3.4, 4.1, 5.0, 2.8, 3.7, 4.4, 5.3, 2.6, 3.5, 4.2, 5.1))

glimpse(fert_data)
summary(fert_data)

# Learn the core dplyr verbs
# filter(): filter rows
fert_data %>% filter(Treatment == 'NPK')

# select(): pick columns
fert_data %>% select(PlotID, Yield_kg)

# mutate(): create new columns
fert_data %>% mutate(Yield_ton = Yield_kg/1000)

# arrange(): sort rows
fert_data %>% arrange(desc(Yield_kg))

# summarise() + group_by()
fert_data %>%
  group_by(Variety) %>%
  summarise(mean_yield = mean(Yield_kg),
            max_yield = max(Yield_kg))

# Introduction to pipe operator: chain functions in readable way
fert_data %>%
  filter(Treatment == 'NPK') %>%
  select(PlotID, Yield_kg)

# miniprojectt
fert_data %>%
  filter(Variety == 'C') %>%
  group_by(Treatment)%>%
  summarise(average = mean(Yield_kg))%>%
  arrange(desc(average))
