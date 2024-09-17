# levenshtein distance op ruwe tekst

# Load the stringdist library
library(stringdist)
library(tidyverse)

df <- read.csv('txt_contents_ruw.csv')

# https://www.rdocumentation.org/packages/stringdist/versions/0.9.12/topics/stringdist

df$identifier <- as.numeric(df$identifier)
# k heb het in drie stukken gehakt omdat het anders teveel geheugen kost en niet draait

df <- df %>%
  slice(1:12)

# Calculate Levenshtein distance for consecutive rows
consecutive_distances <- data.frame(
  id1 = df$identifier[-nrow(df)],  # All ids except the last one
  id2 = df$identifier[-1],         # All ids except the first one
  distance = mapply(function(content1, content2) {
    stringdist(content1, content2, method = "lv")
  }, df$content[-nrow(df)], df$content[-1])  # Apply stringdist for consecutive rows
)

# Display the result
# view(consecutive_distances)

write.csv(consecutive_distances, 'levenstein1.csv')


df <- read.csv('txt_contents_ruw.csv')
df <- df %>%
  slice(12:24)

# Calculate Levenshtein distance for consecutive rows
consecutive_distances <- data.frame(
  id1 = df$identifier[-nrow(df)],  # All ids except the last one
  id2 = df$identifier[-1],         # All ids except the first one
  distance = mapply(function(content1, content2) {
    stringdist(content1, content2, method = "lv")
  }, df$content[-nrow(df)], df$content[-1])  # Apply stringdist for consecutive rows
)

# Display the result
# view(consecutive_distances)

write.csv(consecutive_distances, 'levenstein2.csv')

df <- read.csv('txt_contents_ruw.csv')
df <- df %>%
  slice(24:28)

# Calculate Levenshtein distance for consecutive rows
consecutive_distances <- data.frame(
  id1 = df$identifier[-nrow(df)],  # All ids except the last one
  id2 = df$identifier[-1],         # All ids except the first one
  distance = mapply(function(content1, content2) {
    stringdist(content1, content2, method = "lv")
  }, df$content[-nrow(df)], df$content[-1])  # Apply stringdist for consecutive rows
)

# Display the result
# view(consecutive_distances)

write.csv(consecutive_distances, 'levenstein3.csv')

df <- read.csv('txt_contents_ruw.csv')
df <- df %>%
  slice(28:38)

# Calculate Levenshtein distance for consecutive rows
consecutive_distances <- data.frame(
  id1 = df$identifier[-nrow(df)],  # All ids except the last one
  id2 = df$identifier[-1],         # All ids except the first one
  distance = mapply(function(content1, content2) {
    stringdist(content1, content2, method = "lv")
  }, df$content[-nrow(df)], df$content[-1])  # Apply stringdist for consecutive rows
)

# Display the result
# view(consecutive_distances)

write.csv(consecutive_distances, 'levenstein4.csv')




