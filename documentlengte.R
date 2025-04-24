#documentlengte 

library(tidyverse)

docs <- read.csv('Froglemmas_evpelt.csv')%>%
  select(-X)%>%
  filter(identifier != c("9", "10", "13"))

# view(docs)

words <- docs%>%
  mutate(wordcount = str_count(content, "\\S+") )

# view(words)

ggplot(words)+
  geom_col(aes(identifier, wordcount))+
  labs(x = 'sessions')

## verschil in woordlengte nog toevoegen: dan correlatie met andere measures bekijken
#TODO

## doclengte verschillen per paar files

df <- words %>%
  mutate(identifier = case_match(identifier,
             40 ~ 38,
             .default = identifier))

df <- df[order(as.numeric(df$identifier)), ]

df2 <- df %>%
  mutate(wordcount_dif = c(NA, abs(diff(wordcount))))


# view(df2)


# Generate the new table with consecutive pairs
df_pairs <- df2 %>%
  mutate(previous_identifier = lag(identifier)) %>%
  filter(!is.na(previous_identifier)) %>%
  mutate(id_pairs = paste(previous_identifier, identifier, sep = "_")) %>%
  select(id_pairs, wordcount_dif)

# view(df_pairs)

worddif <- df_pairs %>%
  mutate(Pairs_id = case_match(id_pairs, "37_38" ~ "37_40", 
                               .default = id_pairs))%>%
  select(-id_pairs)

wordplot <- worddif %>%
  mutate(Pairs_id = factor(Pairs_id, levels = unique(Pairs_id[order(
    as.numeric(gsub("_.*", "", Pairs_id)),  # Extract first part of pair_ids
    as.numeric(gsub(".*_", "", Pairs_id))   # Extract second part of pair_ids
  )])))


ggplot(wordplot)+geom_col(aes(Pairs_id, wordcount_dif))+
  theme_minimal()+
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
  

sim_doc <- read.csv('similaritymatrix_pairs_docs.csv')%>%
  rename(similarity_doc = similarity)%>%
  select(-X)

sim_lemmas <- read.csv('similaritymatrixoplemmas_pairs.csv')%>%
  rename(similarity_lemmas = similarity)%>%
  select(-X)

levdist <- read.csv('levenshteindistances.csv')%>%
  rename(Pairs_id = pair_id, lev_distance = distance)%>%
  select(lev_distance, Pairs_id)


table <- worddif %>%
  left_join(sim_doc, by = "Pairs_id") %>%
  left_join(sim_lemmas, by = "Pairs_id")%>%
  left_join(levdist)

 view(table)

# zou een negatieve relaties verwachten tussen word count diff en de similarity


# Select numeric columns from the table
numeric_columns <- table %>%
  select(where(is.numeric))

# Compute the correlation matrix
cor_matrix <- cor(numeric_columns, use = "complete.obs")

# Print the correlation matrix
print(cor_matrix)

 
library(Hmisc)

# Compute correlations
numeric_columns <- table %>% select(where(is.numeric))
result <- rcorr(as.matrix(numeric_columns))

# Correlation matrix
print(result$r)

# p-value matrix
print(result$P)

# Round the p-value matrix to 3 decimal places
rounded_pvalues <- round(result$P, 3)

# Print the rounded p-value matrix
print(rounded_pvalues)



