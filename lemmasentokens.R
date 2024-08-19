# lemmas en tokens 
library(tidyverse)
lem <- read.csv('uniekelemmas.csv')
# names(lem)
colnames(lem) <- c("X", "pair_ids", "unique_in_earlier_lem", "unique_in_later_lem")

tok <- read.csv('unieketokens.csv')
colnames(tok) <- c("X", "pair_ids", "unique_in_earlier_tok", "unique_in_later_tok")

df <- lem %>%
  left_join(tok)%>%
  select(-X)

 # view(df)

count_tokens_between_commas <- function(text) {
  # Split the text by commas
  tokens <- unlist(strsplit(text, ","))
  # Count the number of tokens
  count <- length(tokens)
  return(count)
}

# Assuming 'lemmatized_data' is your dataframe with the 'content' column
df <- df %>%
  mutate(countofLemEarly = sapply(unique_in_earlier_lem, count_tokens_between_commas),
         countofLemLate = sapply(unique_in_later_lem, count_tokens_between_commas),
         countofTokEarly = sapply(unique_in_earlier_tok, count_tokens_between_commas),
         countofTokLate = sapply(unique_in_later_tok, count_tokens_between_commas))

# Display the updated dataframe
 # view(df)



 ## langere tabel maken voor grafiekje lemmas ####

long_data <- df %>%
  gather(key = "variable", value = "count", countofLemEarly, countofLemLate)%>%
  select(pair_ids, variable, count)

manual_order <- c("0_5", "5_10", "10_15", "15_20", "20_25", "25_30", 
                  "30_35", "35_40")  # Example order, adjust as needed

# Convert pair_ids to a factor with the specified levels
long_data$pair_ids <- factor(long_data$pair_ids, levels = manual_order)

# view(long_data)




# Plot the data voor lemmas
ggplot(long_data, aes(x = pair_ids, y = count, fill = variable)) +
  geom_col(position = "dodge") +
    labs(title = "Count of Unique Lemmas",
       x = "Pair IDs",
       y = "Count of Lemmas",
       fill = "Lemmas in") +
  theme_minimal()


#### langere tabel voor plotten tokens####

long_data2 <- df %>%
  gather(key = "variable", value = "count", countofTokEarly, countofTokLate)%>%
  select(pair_ids, variable, count)

manual_order <- c("0_5", "5_10", "10_15", "15_20", "20_25", "25_30", 
                  "30_35", "35_40")  # Example order, adjust as needed

# Convert pair_ids to a factor with the specified levels
long_data2$pair_ids <- factor(long_data$pair_ids, levels = manual_order)

# view(long_data)




# Plot the data voor lemmas
ggplot(long_data2, aes(x = pair_ids, y = count, fill = variable)) +
  geom_col(position = "dodge") +
  labs(title = "Count of Unique Tokens",
       x = "Pair IDs",
       y = "Count of Tokens",
       fill = "Tokens in") +
  theme_minimal()






