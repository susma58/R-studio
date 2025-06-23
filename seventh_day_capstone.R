### Capstone project and real-world applications ###


# Bring everything together to complete a realistic project using multi-variable dataset:
#   soil data
#   weather data
#   crop yield data
#   analysis, modeling and visualization
# Designed to simulate real agricultural research or field study reports

library(tidyverse)

data <- read.csv('capstone.csv')
glimpse(data)
summary(data)


# Visualize Yield Differences
# Yield by crop and district
ggplot(data, aes(x = Crop, y = Yield_kg_per_ha, fill = District))+ 
  geom_bar(stat = 'identity', position = position_dodge())+
  labs(title = 'Crop Yield by District')+
  theme_minimal()

# Effect of soil ph and organic matter
ggplot(data, aes(x = Soil_pH, y = Yield_kg_per_ha, color = Crop))+
  geom_point(size = 3)+
  geom_smooth(method = 'lm', se = FALSE)+
  labs(title = 'Effect of Soil pH on Yield')+
  theme_light()


ggplot(data, aes(x = Organic_Matter_., y = Yield_kg_per_ha, color = District))+
  geom_point(size = 3)+
  geom_smooth(method = 'lm', se = FALSE)+
  labs(title = 'Organic matter vs Yield')+
  theme_light()


# Groupwise summary and correlation
# Average yield per crop
data %>%
  group_by(Crop) %>%
  summarise(avg_yield = mean(Yield_kg_per_ha), .groups = 'drop')

data %>%
  select(Yield_kg_per_ha, Soil_pH, Organic_Matter_., Avg_Seasonal_Rainfall_mm, Avg_Seasonal_Temp_C) %>%
  cor () %>%
  round(2)


# Build a simple linear model
# let's predict yield using weather and soil data
model <- lm(Yield_kg_per_ha ~ Soil_pH + Organic_Matter_. + Avg_Seasonal_Rainfall_mm + Avg_Seasonal_Temp_C, data = data)
summary(model)

# You will see which factors are most influential on yield - check p-values and coeffecients


# Generate Report Tabl
# Create summary table with grouped stats:
data %>% 
  group_by(District, Crop) %>%
  summarise(
    Mean_Yield = mean(Yield_kg_per_ha),
    Mean_Temp = mean(Avg_Seasonal_Temp_C),
    Total_Rain = mean(Avg_Seasonal_Rainfall_mm),
    .groups = 'drop'
  )



# Challenge 
# Try these hands-on tasks:
# Which crop is the most sensitive to rainfall variation?
# For each district, find the year with highest yield and explain the possible reason.
# Build seperate linear models by crop (group_by(crop) + do() or nest() + map())
# Visualize yield trends across years for each crop and district
# Predict yield in a 'new year' using the model and predict()



# Optional Final Project
# Use your own local agriculture dataset, and:
#   Clean and transform it using tidyverse
#   Visualize spatial and temporal patterns
#   Model yield or pest/disease response
#   Write a short summary (can export with knitr or quarto)