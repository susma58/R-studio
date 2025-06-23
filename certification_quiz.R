# 🧪 Section A: Multiple Choice (2 points each)
# 1. What does the filter() function do in dplyr?
#   ✅ B. Filters rows based on conditions
# Explanation: filter() selects rows based on logical conditions.
# 
# 2. Which function would you use to get average yield per crop?
#   ✅ B. group_by() + summarise()
# Explanation: Grouping followed by summarising is the correct approach to compute group-wise summaries.
# 
# 3. Which of the following creates a scatter plot in ggplot2?
#   ✅ C. geom_point()
# Explanation: geom_point() creates a scatter plot by plotting individual points.
# 
# 4. What is the role of lm() in R?
#   ✅ B. Linear modeling
# Explanation: lm() fits linear models (e.g., lm(y ~ x)).
# 
# 5. Which pipe operator is most commonly used in tidyverse?
#   ✅ C. %>%
#   Explanation: The magrittr pipe %>% is widely used in tidyverse workflows.





# 📈 Section B: Coding (3 points each)

# 6. Write tidyverse code to calculate average yield per district.
# library(dplyr)

# df %>%
#   group_by(District) %>%
#   summarise(Avg_Yield = mean(Yield, na.rm = TRUE))


# 7. Write code to plot Soil_pH vs Yield_kg_per_ha with color by Crop.
# library(ggplot2)
# ggplot(df, aes(x = Soil_pH, y = Yield_kg_per_ha, color = Crop)) +
#   geom_point()



# 8. Given a dataset data, filter all rows where crop is “Wheat” and soil pH > 6.0
# data %>%
#   filter(Crop == "Wheat", Soil_pH > 6.0)


 
# 9. Write code to create a linear model to predict yield using all soil and weather variables.
# Assuming soil and weather variables are all except non-predictor ones (like Crop, District, etc.):
# model <- lm(Yield ~ ., data = df)
# Or, more specifically (you can adjust variables accordingly):
# model <- lm(Yield ~ Soil_pH + Rainfall + Temperature, data = df)



# 10. Use arrange() to show the top 5 highest-yielding records.
# df %>%
#   arrange(desc(Yield)) %>%
#   head(5)