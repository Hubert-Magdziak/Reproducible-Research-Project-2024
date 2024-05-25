# Libraries
library(dplyr)
library(ggplot2)

# Read the data
data <- read.csv(file = "preprocessed_data.csv")
data <- data %>% select(-X)

# Check the structure
str(data)

# Exploratory Data Analysis

# Summary statistics
data %>%
  select(-c(year_month, time)) %>%
  group_by(country) %>%
  summarize(mean_sky = mean(sky), 
            mean_temperature = mean(temperature),
            sum_streams = sum(streams)) %>%
  arrange(desc(sum_streams))

# Check the distribution of variables

# Write a function "plot_hist" to plot the distribution of numeric variable

plot_hist <- function(df, x) {
  if (!is.character(df[[x]])){
    hist(df[[x]], 
         main = paste('Histogram of variable', x),
         col = "lightblue",
         xlab = x)
  } else {
    print("Wrong type!")
  }
}

plot_hist(data, 'af_key')
