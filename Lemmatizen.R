# inlezen en lemmatizeren

library(tidyverse)
library(udpipe)

# Define the path to the directory containing the text files
path_to_files <- "Emilia_versies"

# List all the .txt files in the directory
file_list <- list.files(path = path_to_files, pattern = "\\.txt$", full.names = TRUE)


# Function to read the content of a single file
read_file_content <- function(file) {
  content <- readLines(file)
  return(paste(content, collapse = "\n"))
}


# Read the content of all files
file_contents <- lapply(file_list, read_file_content)

# Function to extract the final numeric part of a filename
extract_numeric_part <- function(file) {
  # Extract the base filename without the directory path and file extension
  base_name <- basename(file)
  base_name <- sub("\\.txt$", "", base_name)
  
  # Extract the final numeric part using a regular expression
  numeric_part <- sub(".*[^0-9]([0-9]+)$", "\\1", base_name)
  
  return(numeric_part)
}



## de laatste versie heb ik even '40' genoemd, maar is niet gelogd
# zo komt ie ook als laatste als ik ze numeriek orden, is wel handig. 
# verder is de identifier het ID nummer en de txt dan de eindversie van die sessie

# Extract the numeric part of all filenames
identifiers <- sapply(file_list, extract_numeric_part)


# Create a data frame with the content and identifiers
data <- data.frame(
  identifier = identifiers,
  content = tolower(unlist(file_contents)),
  stringsAsFactors = FALSE
)

 view(data)

write.csv(data, 'txt_contents_ruw.csv')

## tot hierboven easypeasy

# 
# # Download the pre-trained model
# ud_model <- udpipe_download_model(language = "dutch")
# model <- udpipe_load_model(ud_model$file_model)
# 
# # Annotate the text data and extract lemmas
# lemmatize_text <- function(text, model) {
#   # Annotate the text using the udpipe model
#   annotation <- udpipe_annotate(model, x = text)
#   annotated_df <- as.data.frame(annotation)
#   
#   # Extract lemmas
#   lemmatized_text <- paste(annotated_df$lemma, collapse = " ")
#   return(lemmatized_text)
# }
# 
# 
# # Apply lemmatization to all text contents
# lemmatized_contents <- lapply(data$content, lemmatize_text, model = model)
# 
# # names(data)
# 
# # Create a data frame with the lemmatized content and identifiers
# lemmatized_data <- data.frame(
#   identifier = data$identifier,
#   content = unlist(lemmatized_contents),
#   stringsAsFactors = FALSE)
# 
# # view(lemmatized_data)
# 
# write.csv(lemmatized_data, 'lemmas.csv')
# 
# 
# 
