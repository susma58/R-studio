### Data visualization in Agriculture with ggplot2 ###
# Need to learn
# Grammar of graphics
# Create visualizations : scatter, bar, boxplots, line, histogram
# Customize plots: titles, schemes, colors, labels
# Facet plots for comparisons (e.g. between treatments/varieties)
# Use plots to visualize agri metrics: growth, yield, pests and rainfall
# Build publication ready plot.spec.coherency(



library(tidyverse)
maize_data <- tibble(
  Plot_ID = 1:12,
  Variety = rep(c('A', 'B', 'C'), each = 4),
  Fertilizer = rep(c('Organic', 'Inorganic'), times = 6),
  Yield_kg = c(2.1, 2.4, 2.2, 2.5, 2.9, 3.0, 2.8, 3.2, 3.5, 3.6, 3.3, 3.7),
  Height_cm = c(120, 125, 122, 130, 135, 138, 133, 137, 145, 147, 144, 150)
)

# scatter plot
ggplot(maize_data, aes(x=Height_cm, y=Yield_kg))+
  geom_point(size = 3, color = 'forestgreen')+
  labs(title = 'Maize Yield vs Height', x = 'Plant_Height', y= 'Yield_kg')+
  theme_minimal()

# Line plot: growth over time
growth_data <- tibble(
  Day = rep(c(10,20,30), times=3),
  Variety = rep(c('A', 'B', 'C'), each = 3),
  Height_cm = c(12, 24, 37, 14, 28, 41, 13, 25, 39)
)

ggplot(growth_data, aes(x = Day, y = Height_cm, color = Variety))+
  geom_line(size = 1.2)+
  geom_point(size = 3)+
  labs(title = 'Maize growth over time', x = 'Days after planting', y = 'Height(cm)')+
  theme_bw()


# Bar plot: Yield by fertilizer type
ggplot(maize_data, aes(x = Fertilizer, y = Yield_kg))+
  geom_bar(stat = 'summary', fun = 'mean', fill = 'skyblue')+
  labs(title = 'Average yield by fertilizer types', y = 'Yield (kg)')+
  theme_classic()


# Boxplot: Distribution of Yield per variety
ggplot(maize_data, aes(x = Variety, y = Yield_kg, fill = Variety))+
  geom_boxplot()+
  labs(title = 'Yield Distribution per Variety')+
  theme_minimal()


# Faceted plot: Yield vs Height by fertilizer
ggplot(maize_data, aes(x = Height_cm, y = Yield_kg))+
  geom_point(aes(color = Variety), size = 3)+
  facet_wrap(~Fertilizer)+
  labs(title = 'Yield vs Height by Fertilizer Type')+
  theme_light()


# Customizing themes and colors
ggplot(maize_data, aes(x = Variety, y = Yield_kg, fill = Fertilizer))+
  geom_col(position = 'dodge')+
  labs(title = 'Yield by Variety and Fertilizer')+
  theme(
    plot.title = element_text(size = 16, face = 'bold', hjust = 0.5),
    axis.title = element_text(size = 14),
    legend.position = 'top'
  )+
  scale_fill_brewer(palette = 'Set2')







# MINI PROJECT
# Create a dataset that includes Rice varieties, Fertilizer organic and inorganic, 
# Days after planting and yield(kg), plant height, number of tillers
# And do:
#   Line plot: height over time
# box plot: yield per variety
# bar plot: average tiller count by fertilizer
# scatter: height vs Yield
