### seasonal tools, regional weather patterns, or prepping data for dashboards and forecasting ###

# By the end of this lesson, you'll be able to:
# Handle and analyze time-series data with lubridate and tidyverse
# Create seasonal plots and trends
# Apply rolling statistics and slider package
# Use custom functions with map()
# Prepare datasets for climate impact models
# Do basic geospatial analysis with maps(bonus)


library(tidyverse)
library(lubridate)
library(slider)
library(zoo)
library(ggplot2)

weather <- read.csv('weather_seasonal_day6.csv')


# Date parsing and feature engineering
# extract year, month, week, and day to help with seasonal aggregation
weather <- weather %>%
  mutate(
    Date = ymd(Date),
    Month = month(Date, label = TRUE),
    Week = week(Date),
    Day = day(Date)
  )


# District-wise trend visualization
# let's look at the trend of rainfall and temperature over time
ggplot(weather, aes(x = Date, y = Temperature_C, color = District))+
  geom_line()+
  labs(title = 'Daily temperature by district')+
  theme_minimal()


ggplot(weather, aes(x = Date, y = Rainfall_mm, color = District))+
  geom_line()+
  labs(title = 'Daily Rainfall by District')+
  theme_minimal()


# Rolling averages (7-day)
# smooth out fluctuations to detect trends using slider::slide_mean()

weather <- weather %>%
  group_by(District) %>%
  arrange(Date) %>%
  mutate(
    Temp_7day = slide_dbl(Temperature_C, mean, .before = 3, .after = 3, .complete = TRUE),
    Rain_7day = slide_dbl(Rainfall_mm, mean, .before = 3, .after = 3, .complete = TRUE)
  )

# PLOT 7-day rolling rainfall
ggplot(weather, aes(x = Date, y = Rain_7day, color = District))+
  geom_line()+
  labs(title = '7-Day Rolling Avg Rainfall by District')+
  theme_minimal()


# Advanced functional programming with purr
# what if you wanted to calculate seasonal summary stats per district dynamically?
# create function to summarise weather
summary_fun <- function(df){
  df %>%
    summarise(
      mean_temp = mean(Temperature_C, na.rm = TRUE),
      total_rain = sum(Rainfall_mm, na.rm = TRUE),
      max_rain = max(Rainfall_mm)
    )
}

# Apply it by nesting and mappng
nested_weather <- weather %>%
  group_by(District) %>%
  nest() %>%
  mutate(summaries = map(data, summary_fun)) %>%
  select(District, summaries) %>%
  unnest(summaries)


# Preparing for modeling
# Aggregate weekly average temperature and total rainfall
model_data <- weather %>%
  group_by(District, Week) %>%
  summarise(
    weekly_temp = mean(Temperature_C, na.rm = TRUE),
    weekly_rain = sum(Rainfall_mm, na.rm = TRUE),
    .groups = 'drop'
  )
glimpse(model_data)


# This can be merged with crop yield data later

# BONUS: Mapping (basic)
# if you want to move into mapping, you can explore sf, leaflet or tmap.
# install packages sf and tmap
# for now just understand that you can bind weather summaries with district shapes for spatial analysis



# Challenge for Day 6
# Which district had the highest rainfall in the 2nd month?
# What was the temperature variability (sd) by month for each district?
# Create a plot of weekly average temperature by district with line smoothing.
# Add cumulative rainfall over time per district