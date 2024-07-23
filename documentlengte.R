#documentlengte 

library(tidyverse)

docs <- read.csv('tokenized.csv')%>%
  select(-X)

# view(docs)

words <- docs%>%
  mutate(wordcount = str_count(content, "\\S+") )

view(words)

ggplot(words)+
  geom_col(aes(identifier, wordcount))+
 scale_x_continuous(breaks = seq(0, 40, by = 5))
  
 
