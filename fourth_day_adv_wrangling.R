### Advanced Data Wrangling Using dplyr ###
# 
# By the end of the day:
# Use dplyr verbs: filter, select, arrange, mutate, summarise, group_by
# Chain operations using pipes |>
# Handle real agricultural datasets (e.g.field trails, soil, weather)
# Perform grouped statistics (e.g. average yield per variety)
# Prepare data for modeling or plotting


# average yield by fertilizer type
maize_data %>%
  group_by(Fertilizer) %>%
  summarise(Avg_yield = mean(Yield_kg), 
            Max_yield = max(Yield_kg), 
            .groups = 'drop')

# summary by variety
maize_data %>%
  group_by(Variety) %>%
  summarise(Mean_height = mean(Height_cm),
            SD_height = sd(Height_cm), 
            .groups = 'drop')

# High-yield plot identification
maize_data %>%
  filter(Yield_kg > 3.4) %>%
  arrange(desc(Yield_kg)) %>%
  select(Plot_ID, Variety, Fertilizer, Yield_kg)



# Mini project = Fertilizer effect summary
# calculate the average yield by fertilizer
# Add a new column: Yield efficiency = Yield kg/ height_cm
# Filter out plots with yield efficiency < 0.025
# show top 5 plots by yield efficiency

maize <- read.csv('maize_data_day3.csv')

# apply same functions to multiple columns with across() inside mutate() or summarise()
