# Libraries
library(dplyr)
library(ggplot2)
library(plm)
library(zoo)
library(lmtest)
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

# Modelling

# Fixed Effects Model
model.fixed <- plm(af_valence ~ sky + temperature + log_streams + 
                     af_danceability + af_energy + af_key + 
                     af_loudness + af_speechiness + af_acousticness + 
                     af_tempo, data = data, index = c("country", "year_month"),
                   model = "within")

summary(model.fixed)

# Random Effects Model
model.random <- plm(af_valence ~ sky + temperature + log_streams + 
                     af_danceability + af_energy + af_key + 
                     af_loudness + af_speechiness + af_acousticness + 
                     af_tempo, data = data, index = c("country", "year_month"),
                   model = "random")

summary(model.random)

# Pooled Regression Model
model.OLS <- lm(af_valence ~ sky + temperature + log_streams + 
                     af_danceability + af_energy + af_key + 
                     af_loudness + af_speechiness + af_acousticness + 
                     af_tempo, data = data)

summary(model.OLS)

# Select between Fixed Effects and Random Effects model

# Hausman test
phtest(model.fixed, model.random)
# p-value < 5% (significance level alpha), we reject null hypothesis in favor
# of alternative hypothesis - Cov(u,X) != 0 - only Fixed Effects Model is appropriate

# Test for poolability
pFtest(model.fixed, model.OLS)
# p-value < 5% (significance level alpha), we reject null hypothesis
# in favor of alternative hypothesis - fixed effects model is more appropriate

# Test for correlation (Breusch-Godfrey test)
pbgtest(model.fixed)
# p-value < 5% (significance level alpha), we reject null hypothesis
# in favor of alternative hypothbesis - serial correlation exists in 
# indiosyncratic errors

# Test for heteroscedasticity (Breusch-Pagan test)
bptest(af_valence ~ sky + temperature + log_streams + 
                  af_danceability + af_energy + af_key + 
                  af_loudness + af_speechiness + af_acousticness + 
                  af_tempo, 
       data = data,
       studentize = T)
# p-value < 5% (significance level alpha), we reject null hypothesis
# in favor of alternative hypothesis - errors in the model are heteroscedastic

# Apply robust standard errors to obtain unbiased estimations
coeftest(model.fixed, vcov. = vcovHC(model.fixed, 
                                     method = "white1",
                                     type = "HC0",
                                     cluster = "group"))
