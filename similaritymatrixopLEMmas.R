# kijken naar python similarity matrix met BERT gemaakt

library(tidyverse)

# df <- read.csv('similarity_matrix_lemmas.csv')
df <- read.csv("similarity_output_lemmasEvP.csv")
 view(df)

df_pairs <- df %>%
    mutate(Pairs_id = factor(pair_ids, levels = unique(pair_ids[order(
    as.numeric(gsub("_.*", "", pair_ids)),  # Extract first part of pair_ids
    as.numeric(gsub(".*_", "", pair_ids))   # Extract second part of pair_ids
  )])))


# view(df_pairs)  

p2 <- ggplot(df_pairs)+
  geom_col(aes(Pairs_id, cosine_similarity))+
  coord_cartesian(ylim = c(0.90, max(df_pairs$cosine_similarity, na.rm = TRUE)))+
  theme_minimal()+
  theme(axis.text.x = element_text(angle = 45, hjust = 1))+
  labs(title = "cosine similarity of sets of unique lemmas")

p2

ggsave("plotsimilarityopLemmas.pdf", plot = p2, device = "pdf", width = 8, height = 6)

