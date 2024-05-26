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

# Write a function "plot_histogram" to plot the distribution of every numeric variable

plot_histograms <- function(data) {
  
  numeric_cols <- sapply(data, is.numeric)
  data_numeric <- data[, numeric_cols]
  
  # Iterate through numeric columns and plot histograms
  for (col in colnames(data_numeric)) {
    hist(data_numeric[[col]], main = paste("Histogram of", col), xlab = col, ylab = "Frequency", col = "blue", border = "black")
  }
}


plot_histograms(data)

