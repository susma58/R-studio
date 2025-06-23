### Relational data handling, nested data workflows, advanced visualization ###


# By the end of the day 5, you'll be able to:
# Perform advanced joins using dplyr
# conduct multi-level grouping and summary statistics
# Use tidy evaluation ({{ }} and across)
# Work with nested dataframes and purrr
# Prepare tidy datasets for regression modeling
# Build clean analysis pipelines for agricultural data


# Load the libraries and Data in R
library(tidyverse)
# Read in the data
maize <- read.csv('maize_day5.csv')         # crop perfomance per plot
weather <- read.csv('weather_day5.csv')     # weather conditions per farmer
farmer <- read.csv('farmer_day5.csv')       # farmer metadata

# Advanced data joins and merging
# join all three datasets to get one enriched dataset
# join maize with farmer and then, weather
maize_full <- maize %>%
  left_join(farmer, by = 'FarmerID') %>%
  left_join(weather, by = 'FarmerID')

glimpse(maize_full)


# multi-level grouping and summarising
# analyze how different combinations affect yield
# average yield per district and variety

maize_full %>%
  group_by(District, Variety) %>%
  summarise(mean_yield = mean(Yield_kg), .groups = 'drop')
# use across() to compute multiple summaries
# summary for both yield and height
maize_full %>%
  group_by(Variety) %>%
  summarise(across(c(Yield_kg, Height_cm), list(mean = mean, sd = sd)))


# Visualizing with ggplot2 (Advanced)
# Use faceting and color mapping for comparison
# Yield by fertilizer and variety
ggplot(maize_full, aes(x = Fertilizer, y = Yield_kg, fill = Variety))+
  geom_boxplot()+
  facet_wrap(~ District)+
  theme_minimal()



# Working with Nested Data + Purrr
# Use nest() + map() for modular analysis per farmer of district

# Nest by district
nested <- maize_full %>%
  group_by(District) %>%
  nest()

# summary per district using map()
nested <- nested %>%
  mutate(stats = map(data, ~ summarise(.x, mean_yield = mean(Yield_kg), n = n())))

# unnest results
nested %>%
  select(District, stats) %>%
  unnest(stats)


# Regression-ready Dataframe
# prepare dataset for modeling yield based on rainfall, temperature, fertilizer
# one hot encoding (tidyverse way)
maize_model_data <- maize_full %>%
  mutate(across(c(Variety, Fertilizer), as.factor)) %>%
  mutate(across(c(Variety, Fertilizer), ~as.numeric(as.factor(.x)))) %>%
  select(Yield_kg, Variety, Fertilizer, Rainfall_mm, Temperature_C)

glimpse(maize_model_data)



# Challenge Project: mini report
# Tasks:
# Which fertilizer gives higher yield across districts?
# Is hybrid variety consistently better across rainfall variations?
# How do rainfall and temperature correlate with yield?
  
# Question 1
maize_full %>%
  group_by(Fertilizer, District) %>%
  summarise(mean_yield = mean(Yield_kg), .groups = 'drop')

# Question 2
ggplot(maize_full, aes(x = Rainfall_mm, y = Yield_kg, color = Variety))+
  geom_point()+
  geom_smooth(method = 'lm')+
  theme_minimal()

# Question 3
maize_full %>%
  summarise(cor_yield_rain = cor(Yield_kg, Rainfall_mm),
            cor_yield_temp = cor(Yield_kg, Temperature_C))
