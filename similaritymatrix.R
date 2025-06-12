# kijken naar python similarity matrix met BERT gemaakt

library(tidyverse)

df <- read.csv('similarity_matrix.csv')

  view(df)

#pairwise vergelijking maken

df$identifier <- as.numeric(df$identifier)


df <- df[order(df$identifier), ]

view(df)
df_wide <- df%>%
  # mutate(identifier2 = identifier+1)%>%
  # mutate(identifier2 = ifelse(identifier2 == 9, 11, identifier2),
  #        identifier2 = ifelse(identifier2 == 13, 14, identifier2))%>%
  # select(-identifier)%>%
  # rename(identifier = identifier2)%>%
  select(identifier, everything())%>%
  pivot_longer(cols = 2:20, names_to = "id", values_to = "similarity")%>%
  mutate(id = gsub("X", "", id))

  view(df_wide)

# view(df)

df_wide$id <- as.numeric(df_wide$id) 
df_wide$identifier <- as.numeric(df_wide$identifier)  

df_pairs <- df_wide %>%
  arrange(id, identifier)
  

df2 <- df_pairs%>%
  mutate(pairs_id = paste(as.character(id), as.character(identifier), sep = "_"))

view(df2)
write.csv(df2,'similaritymatrix_pairs_docs.csv')
## met de hand geselecteerd... 

df_pairs <- read.csv('similaritymatrix_pairs_docs.csv')

names(df_pairs)

df_pairs2 <- df_pairs %>%
  mutate(Pairs_id = factor(pairs_id, levels = unique(pairs_id[order(
    as.numeric(gsub("_.*", "", pairs_id)),  # Extract first part of pair_ids
    as.numeric(gsub(".*_", "", pairs_id))   # Extract second part of pair_ids
  )])))


p1 <- ggplot(df_pairs2)+
  geom_col(aes(Pairs_id, similarity))+
  coord_cartesian(ylim = c(0.90, max(df_pairs$similarity, na.rm = TRUE)))+
  theme_minimal()+
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

p1
ggsave("plotsimilarityopDocs.pdf", plot = p1, device = "pdf", width = 8, height = 6)



