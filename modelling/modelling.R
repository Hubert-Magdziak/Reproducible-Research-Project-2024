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
  for (col in colnames(data_numeric)) {
    hist(data_numeric[[col]], main = paste("Histogram of", col), xlab = col, ylab = "Frequency", col = "blue", border = "black")
  }
}


plot_histograms(data)

# Feature engineering

# Apply log(x + 1) transformation for variables with highly non symmetric distribution
par(mfrow = c(1,2))
hist(log1p(data$streams), main = "Histogram of variable log_streams")
hist(data$streams, main = "Histogram of variable streams")
par(mfrow = c(1,1))

data$log_streams <- log1p(data$streams)

par(mfrow = c(1,2))
hist(data$af_acousticness, main = "Histogram of variable log_af_acousticness")
hist(log1p(data$af_acousticness), main = "Histogram of variable af_acousticness")
par(mfrow = c(1,1))

data$log_af_acousticness <- log1p(data$af_acousticness)
