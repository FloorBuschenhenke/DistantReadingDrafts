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



# Convert pair_ids to a factor with the specified levels
# long_data$pair_ids <- factor(long_data$pair_ids, levels = manual_order)

long_data$pair_ids <- factor(long_data$pair_ids)
 # view(long_data)

long_data_lemmas <- long_data %>%
  slice(1:38)%>%
  mutate(pair_ids = factor(pair_ids, levels = unique(pair_ids[order(
    as.numeric(gsub("_.*", "", pair_ids)),  # Extract first part of pair_ids
    as.numeric(gsub(".*_", "", pair_ids))   # Extract second part of pair_ids
  )])))

long_data_lem2 <- long_data %>%
  slice(39:76)%>%
  mutate(pair_ids = factor(pair_ids, levels = unique(pair_ids[order(
    as.numeric(gsub("_.*", "", pair_ids)),  # Extract first part of pair_ids
    as.numeric(gsub(".*_", "", pair_ids))   # Extract second part of pair_ids
  )])))

long_data <- bind_rows(long_data_lemmas, long_data_lem2)

view(long_data)
# Plot the data voor lemmas
ggplot(long_data, aes(x = pair_ids, y = count, fill = variable)) +
  geom_col(position = "dodge") +
    labs(title = "Count of Unique Lemmas",
       x = "Pair IDs",
       y = "Count of Lemmas",
       fill = "Lemmas in") +
  theme_minimal()+
  theme(axis.text.x = element_text(angle = 45, hjust = 1))



#### langere tabel voor plotten tokens####

long_data2 <- df %>%
  gather(key = "variable", value = "count", countofTokEarly, countofTokLate)%>%
  select(pair_ids, variable, count)


long_data_tok1 <- long_data2 %>%
  slice(1:38)%>%
  mutate(pair_ids = factor(pair_ids, levels = unique(pair_ids[order(
    as.numeric(gsub("_.*", "", pair_ids)),  # Extract first part of pair_ids
    as.numeric(gsub(".*_", "", pair_ids))   # Extract second part of pair_ids
  )])))

long_data_tok2 <- long_data2 %>%
  slice(39:76)%>%
  mutate(pair_ids = factor(pair_ids, levels = unique(pair_ids[order(
    as.numeric(gsub("_.*", "", pair_ids)),  # Extract first part of pair_ids
    as.numeric(gsub(".*_", "", pair_ids))   # Extract second part of pair_ids
  )])))

long_data_tok <- bind_rows(long_data_tok1, long_data_tok2)


# Plot the data voor lemmas
ggplot(long_data_tok, aes(x = pair_ids, y = count, fill = variable)) +
  geom_col(position = "dodge") +
  labs(title = "Count of Unique Tokens",
       x = "Pair IDs",
       y = "Count of Tokens",
       fill = "Tokens in") +
  theme_minimal()+
  theme(axis.text.x = element_text(angle = 45, hjust = 1))






