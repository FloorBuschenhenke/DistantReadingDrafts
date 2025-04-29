# kijken naar python similarity matrix met BERT gemaakt

library(tidyverse)

df <- read.csv('similarity_matrix.csv')

 # view(df)

#pairwise vergelijking maken

df$identifier <- as.numeric(df$identifier)

df <- df[order(df$identifier), ]

view(df)
df_wide <- df%>%
  pivot_longer(cols = 2:19, names_to = "id", values_to = "similarity")%>%
  mutate(id = gsub("X", "", id))

 # view(df_wide)

# view(df)

##handiger om de gepubli versie te hernoemen naar 38 voor de scriptjes

df_wide$id <- as.numeric(df_wide$id) 
df_wide$identifier <- as.numeric(df_wide$identifier)  

df_pairs <- df_wide %>%
  group_by(identifier)%>%
  mutate(pairs = ifelse(id == identifier + 1, first(id), NA))%>%
  filter(!is.na(pairs))%>%
  select(-pairs)%>%
  mutate(Pairs_id = str_c(as.character(identifier), as.character(id), sep = "_"))%>%
  ungroup()%>%
  select(-id, -identifier)%>%
  mutate(Pairs_id = factor(Pairs_id, levels = unique(Pairs_id[order(
    as.numeric(gsub("_.*", "", Pairs_id)),  # Extract first part of pair_ids
    as.numeric(gsub(".*_", "", Pairs_id))   # Extract second part of pair_ids
  )])))
  

 view(df_pairs)  

df_pairs_hernoemd <- df_pairs

write.csv(df_pairs_hernoemd, 'similaritymatrix_pairs_docs.csv')

p1 <- ggplot(df_pairs_hernoemd)+
  geom_col(aes(Pairs_id, similarity))+
  coord_cartesian(ylim = c(0.90, max(df_pairs$similarity, na.rm = TRUE)))+
  theme_minimal()+
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

p1
ggsave("plotsimilarityopDocs.pdf", plot = p1, device = "pdf", width = 8, height = 6)



