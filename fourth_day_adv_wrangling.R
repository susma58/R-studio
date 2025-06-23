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

# across(): apply functions across columns
# apply the same function to multiple columns with across() inside mutate() or summarise()
# calculate mean and SD of yield and height by fertilizer
maize_data %>%
  group_by(Fertilizer)%>%
  summarise(across(c(Yield_kg, Height_cm), list(mean = mean, sd = sd), .names = "{.col}_{.fn}"))

# case_when(): advanced conditional creation
# use case_when() for multiple IF-ELSE logic, perfect for categorizing plots
maize_data <- maize_data %>%
  mutate(Yield_Category = case_when(
    Yield_kg < 2.5 ~ 'low',
    
    Yield_kg < 3.2 ~ 'Medium',
    
    TRUE ~ 'High'
    ))


# rowwise(): Row-level computation
# some functions are row-specific especially when comparing multiple measurements per row
maize_data <- maize_data %>%
  rowwise() %>%
  mutate(PlantEff = Yield_kg / Height_cm) %>%
  ungroup()
view(maize_data)
# useful in mixed crop experiments, e.g. maize-legume yield ratios, NPK response ratios etc.


# custom summaries: CV%, Range, IQR
maize_data %>%
  group_by(Variety) %>%
  summarise(
    Yield_CV = sd(Yield_kg) / mean(Yield_kg) * 100,
    Height_Range = max(Height_cm) - min(Height_cm),
    Height_IQR = IQR(Height_cm),
    .groups = 'drop'
  )
# very helpful in varietal performance trials and environment variability studies


# Window functions lag(), lead()
# used when rows are ordered, such as time series or treatment levels
# imagine these were chronological yields
maize_data <- maize_data %>%
  arrange(Plot_ID) %>%
  mutate(Yield_Change = Yield_kg - lag(Yield_kg))
view(maize_data)


# n() and n_distinct() : count summaries
maize_data %>%
  group_by(Variety) %>%
  summarise(
    Total_Plots = n(),
    Fertilizer_Types = n_distinct(Fertilizer)
  )
# use this in designs like RCBD or split plot when checking balance or replication


library(dplyr)

# Custom function with tidy evaluation {{}}
# create your own function to summarise any variable by group:
summary_by_group <- function(df, group_var, target_var) {
  df %>%
    group_by({{group_var}}) %>%
    summarise(
      Mean = mean({{target_var}}, na.rm = TRUE),
      SD = sd({{target_var}}, na.rm = TRUE),
      .groups = 'drop'
    )
}

# use it!
summary_by_group(maize, Fertilizer, Yield_kg)

# Mini advance case study: identification of best performing fertilizer per variety
maize %>%
  group_by(Variety, Fertilizer) %>%
  summarise(Avg_Yield = mean(Yield_kg), .groups = 'drop') %>%
  group_by(Variety) %>%
  slice_max(order_by = Avg_Yield, n=1)
# This is great when recommending context-specific input management (e.g., best fertilizer per crop)


# Optional challenge
pivoted <- maize %>%
  group_by(Variety, Fertilizer) %>%
  summarise(Yield = mean(Yield_kg), .groups = 'drop') %>%
  pivot_wider(names_from = Fertilizer, values_from = Yield) %>%
  mutate(Percent_Diff = ((Inorganic - Organic) / Organic) * 100)




# Assignment
# Create a summary that:
# Groups by Variety
# Calculates Yield CV, mean height, and number of organic plots
# Filters only those height > 130
# Sorts by Yield CV descending



