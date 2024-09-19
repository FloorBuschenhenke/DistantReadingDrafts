# levenshtein distance op ruwe tekst

# Load the stringdist library
library(stringdist)
library(tidyverse)

df <- read.csv('txt_contents_ruw.csv')

# https://www.rdocumentation.org/packages/stringdist/versions/0.9.12/topics/stringdist

df$identifier <- as.numeric(df$identifier)
df <- df %>% arrange(identifier)

# k heb het in vier stukken gehakt omdat het anders teveel geheugen kost en niet draait

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
df$identifier <- as.numeric(df$identifier)
df <- df %>% arrange(identifier)

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
df$identifier <- as.numeric(df$identifier)
df <- df %>% arrange(identifier)

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
df$identifier <- as.numeric(df$identifier)
df <- df %>% arrange(identifier)
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

## heel specifiek nog voor de laatste 

df <- read.csv('txt_contents_ruw.csv')
df$identifier <- as.numeric(df$identifier)
df <- df %>% arrange(identifier)
df <- df %>%
  filter(identifier == 37 | identifier == 40)

# Calculate Levenshtein distance for consecutive rows
# Find the rows where identifier is 37 and 40
id1_row <- which(df$identifier == 37)
id2_row <- which(df$identifier == 40)

# Create the data frame for consecutive distances between these specific rows
consecutive_distances <- data.frame(
  id1 = df$identifier[id1_row],  # Row where identifier is 37
  id2 = df$identifier[id2_row],  # Row where identifier is 40
  distance = stringdist(df$content[id1_row], df$content[id2_row], method = "lv")  # Calculate string distance
)



# Display the result
# view(consecutive_distances)

write.csv(consecutive_distances, 'levenstein5.csv')

lv1 <- read.csv('levenstein1.csv')
lv2 <- read.csv('levenstein2.csv')
lv3 <- read.csv('levenstein3.csv')
lv4 <- read.csv('levenstein4.csv')
lv5 <- read.csv('levenstein5.csv')

lv <- rbind(lv1, lv2, lv3, lv4, lv5)

view(lv)

lv2 <- lv%>% select(-X)
lv2$pair_id <- paste(lv$id1, lv$id2, sep = "_")

lv3 <- lv2%>%
  mutate(pair_id = factor(pair_id, levels = unique(pair_id[order(
    as.numeric(gsub("_.*", "", pair_id)),  # Extract first part of pair_ids
    as.numeric(gsub(".*_", "", pair_id))   # Extract second part of pair_ids
  )])))

 view(lv3)

write.csv(lv3, 'levenshteindistances.csv')

ggplot(lv3)+geom_col(aes(pair_id, distance))+
  theme_minimal()+
  theme(axis.text.x = element_text(angle = 45, hjust = 1))




