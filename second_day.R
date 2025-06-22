### Tidy Data and Reshaping with tidyr ###
# Learn to reshape data using pivot_longer() and pivot_wider()
# Handle missing values with drop_na() and replace_na()
# Clean messy names with janitor::clean_names()
# Read agri-case study: maize growth tracking
# what is tidy data?
# Each variable in a column; each observation in a row; each unit of observation in its own table

# create a sample "messy" dataset (wide format)
library(tidyverse)
library(readr)

maize_growth <- tibble(
  Plot_id = 1:4,
  Variety = c('A', 'B', 'C', 'D'),
  Height_Day10 = c(14.2, 13.8, 15.0, 14.7),
  Height_Day20 = c(25.5, 26.1, 27.0, 26.4),
  Height_Day30 = c(38.0, 39.5, 40.2, 41.1)
)

glimpse(maize_growth)

# reshape wide data into long format using pivot_longer()
maize_long <- maize_growth %>%
  pivot_longer(
    cols = starts_with('Height_'),
    names_to = 'Day',
    values_to = 'Height_cm'
  )
view(maize_long)
view(maize_growth)

# make the day number a separate column
maize_long <- maize_long %>%
  mutate(Day = str_remove(Day, 'Height_Day') %>% as.integer())
view(maize_long)

# reshape long data to wide using pivot_wider()
maize_long %>% 
  pivot_wider(names_from = Day, values_from = Height_cm, names_prefix = 'Day')





## Handle missing values
# add some missing values
maize_long$Height_cm[c(2,5)] <- NA

# drop missing rows
maize_long %>%
  drop_na(Height_cm)
view(maize_long)

# replace missing values with mean height
mean_height <- mean(maize_long$Height_cm, na.rm = TRUE)

maize_long %>%
  mutate(Height_cm = replace_na(Height_cm, mean_height))




## Clean column names with janitor
install.packages('janitor')
library(janitor)

messy_data <- tibble(
  'Plot_id' = 1:2,
  'Yield (kg)' = c(3.4, 4.1)
)

view(messy_data)

clean_data <- messy_data %>% clean_names()
clean_data
view(clean_data)


### Mini project
# Create a dataset with 3 varieties and height at 3 stages
# Convert it to tidy format
# Clean column names
# Replace missing values with average
# Create a line plot of average height over time


maize_grow <- tibble(
  Plot_ID = 1:3,
  variety = c('A', 'B', 'c'),
  Height_Day20 = c(14.2, 13.8, 15.0),
  Height_Day30 = c(25.5, 26.1, 27.0),
  Height_Day45 = c(38.0, 39.5, 40.2))


maize_grow %>%
  pivot_longer(cols = starts_with('Height_'),
               names_to = 'Day', values_to = 'Height_cm') %>%
  mutate(Day = str_remove(Day, 'Height_Day') %>% as.integer()) %>%
  group_by(Day) %>%
  summarise(avg_height = mean(Height_cm, na.rm = TRUE)) %>%
  ggplot(aes(x=Day, y=avg_height))+
  geom_line()+
  geom_point()+
  labs(title = 'Average maize height over time', 
       x = 'Days after planting', y= 'Height (cm)')
  