## revisie-annotatie uit proefschrift
# alleen de revisies in bestaande zinnen meenemen
## geen 'sentencelevel'? (als het een verwijdering is, want dat neem ik al mee
## in de narrativescores)
# per tweetal sessies het verschil

library(tidyverse)


df <- read.csv("vpelt_revisionsinoldsentences.csv") 

df_revs <- df%>%
  filter(!str_detect(semantic_effect,"\\|"))%>%
  mutate(semantic_effect = recode(semantic_effect, "language correctness" = "languagecorrectness"))%>%
  mutate(semantic_effect = recode(semantic_effect, "meaning-changing" = "meaningchanging"))%>%
  group_by(session_number, semantic_effect)%>%
    summarise(n = n())%>%
   pivot_wider(names_from = semantic_effect, values_from = n)%>%
      mutate(revisionscore = sum(languagecorrectness*1, style*2, meaningchanging*3, na.rm=TRUE))%>%
  select(session_number, revisionscore)
 
view(df_revs)

write.csv(df_revs, 'revisionscore.csv')



revs2<- df_revs%>%
    ungroup()%>%
  ## this one is the difference between current identifier and previous one, id0 = baseline
  mutate(revision_diff = revisionscore-lag(revisionscore))

view(revs2)


## pair_id maken


df <- revs2%>%
  rename(identifier = session_number)

df$identifier <- as.numeric(df$identifier)
df <- df[order(as.numeric(df$identifier)), ]


# Generate the new table with consecutive pairs
df_pairs <- df %>%
  ungroup()%>%
  mutate(previous_identifier = lag(identifier))%>%
  filter(!is.na(previous_identifier)) %>%
  mutate(id_pairs = paste(previous_identifier, identifier, sep = "_"))%>%
  select(-identifier, -previous_identifier)%>%
  select(id_pairs, everything())


view(df_pairs)

#check of er sessies missen

write.csv(df_pairs, 'revisionscores.csv')

