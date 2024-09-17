# kijken naar python similarity matrix met BERT gemaakt

library(tidyverse)

df <- read.csv('similarity_matrix.csv')

 view(df)

#pairwise vergelijking maken

df$identifier <- as.numeric(df$identifier)

df <- df[order(df$identifier), ]

df_wide <- df%>%
  pivot_longer(cols = 2:40, names_to = "id", values_to = "similarity")%>%
  mutate(id = gsub("X", "", id))

 view(df_wide)

# view(df)

##handiger om de gepubli versie te hernoemen naar 38 voor de scriptjes

df_wide <- df_wide %>%
  mutate(identifier = recode(as.character(identifier), "40" = "38"),
         id = recode(id, "40" = "38"))

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

df_pairs_hernoemd <- df_pairs%>%
  mutate(Pairs_id = recode(Pairs_id, "37_38" = "37_40"))

ggplot(df_pairs_hernoemd)+
  geom_col(aes(Pairs_id, similarity))+
  coord_cartesian(ylim = c(0.90, max(df_pairs$similarity, na.rm = TRUE)))+
  theme_minimal()+
  theme(axis.text.x = element_text(angle = 45, hjust = 1))





