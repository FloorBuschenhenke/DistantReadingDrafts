#documentlengte 

library(tidyverse)

# docs <- read.csv('Froglemmas_evpelt.csv')%>%
docs <- read.csv('txt_contents_ruw.csv')%>%
  select(-X)

 # view(docs)

words <- docs%>%
  mutate(wordcount = str_count(content, "\\S+") )

# view(words)

ggplot(words)+
  geom_col(aes(factor(identifier), wordcount))+
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
  
write.csv(wordplot, 'doclengthpairdif.csv')

