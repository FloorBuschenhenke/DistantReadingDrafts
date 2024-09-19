# woordsoorten filteren
library(tidyverse)
library(udpipe)

# https://www.rdocumentation.org/packages/udpipe/versions/0.8.11


data <- read.csv('txt_contents_ruw.csv')

# Download the pre-trained model
ud_model <- udpipe_download_model(language = "dutch")
model <- udpipe_load_model(ud_model$file_model)

# Annotate the text data and extract lemmas
annotate_text <- function(text, model) {
  # Annotate the text using the udpipe model
  annotation <- udpipe_annotate(model, x = text)
  
  annotated_df <- as.data.frame(annotation)
  
  # https://universaldependencies.org/nl/index.html
  ## ADJ = adjectives
  ## ADV = adverbs
  ## NOUN 
  ## VERB
  
  annotated_df2 <- annotated_df%>%
    filter(upos %in% c("NOUN", "VERB", "ADV", "ADJ"))
  
  # Extract lemmas
  lemmatized_text <- paste(annotated_df2$lemma, collapse = " ")
  return(lemmatized_text)
  
  
}
  

# Apply lemmatization to all text contents
annotated_contents <- lapply(data$content, annotate_text, model = model)

 # glimpse(annotated_contents)

# Create a data frame with the lemmatized content and identifiers
lemmatized_data <- data.frame(
  identifier = data$identifier,
  content = unlist(annotated_contents),
  stringsAsFactors = FALSE)

view(lemmatized_data)

write.csv(lemmatized_data, 'gefilterdelemmas.csv')





