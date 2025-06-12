# correlaties 
library(tidyverse)

nardif <- read.csv('eventnarrativitydiff.csv')%>%
  select(Pairs_id, narrativediff)

worddif <- read.csv('doclengthpairdif.csv')%>%
  select(-X)

sim_doc <- read.csv('similaritymatrix_pairs_docs.csv')%>%
  rename(similarity_doc = similarity, Pairs_id = pairs_id)%>%
  select(-identifier, -id)


sim_lemmas <- read.csv('similaritymatrixoplemmas_pairs.csv')%>%
  rename(similarity_lemmas = similarity)%>%
  select(-X)

  table <- worddif %>%
  left_join(sim_doc, by = "Pairs_id") %>%
  left_join(sim_lemmas, by = "Pairs_id")%>%
    left_join(nardif)

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


