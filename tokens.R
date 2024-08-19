# alleen tokens

data <- read.csv('txt_contents_ruw.csv')

# Download the pre-trained model for English
ud_model <- udpipe_download_model(language = "dutch")
model <- udpipe_load_model(ud_model$file_model)

# Annotate the text data and extract lemmas
tokenize_text <- function(text, model) {
  # Annotate the text using the udpipe model
  annotation <- udpipe_annotate(model, x = text)
  annotated_df <- as.data.frame(annotation)
  
  # Extract tokens
  tokenized_text <- paste(annotated_df$token, collapse = " ")
  return(tokenized_text)
}



# Apply tokenization
tokenized_contents <- lapply(data$content, tokenize_text, model = model)

tokenized_data <- data.frame(
  identifier = data$identifier,
  content = unlist(tokenized_contents),
  stringsAsFactors = FALSE)

view(tokenized_data)

write.csv(tokenized_data, 'tokenized.csv')

