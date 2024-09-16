# kijken naar python similarity matrix met BERT gemaakt

library(tidyverse)

df <- read.csv('similarity_matrix_lemmas.csv')

# view(df)

#pairwise vergelijking maken

df$identifier <- as.numeric(df$identifier)

df <- df[order(df$identifier), ]

df_wide <- df%>%
  pivot_longer(cols = 2:10, names_to = "id", values_to = "similarity")%>%
  mutate(id = gsub("X", "", id))

# view(df_wide)

df_wide$id <- as.numeric(df_wide$id)

df_pairs <- df_wide %>%
  group_by(identifier)%>%
  mutate(pairs = ifelse(id == identifier + 5, first(id), NA))%>%
  filter(!is.na(pairs))%>%
  select(-pairs)%>%
  mutate(Pairs_id = str_c(as.character(identifier), as.character(id), sep = "_"))%>%
  ungroup()%>%
  select(-id, -identifier)
  

# view(df_pairs)  

manual_order <- c("0_5", "5_10", "10_15", "15_20", "20_25", "25_30", 
                  "30_35", "35_40")  # Example order, adjust as needed

# Convert pair_ids to a factor with the specified levels
df_pairs$Pairs_id <- factor(df_pairs$Pairs_id, levels = manual_order)

ggplot(df_pairs)+
  geom_col(aes(Pairs_id, similarity))+
  coord_cartesian(ylim = c(0.90, max(df_pairs$similarity, na.rm = TRUE)))+
  theme_minimal()+labs(title = "cosine similarity of sets of unique lemmas")





