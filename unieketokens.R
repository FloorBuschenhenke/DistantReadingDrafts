#unieke tokens 

library(tidyverse)

df <- read.csv('tokenized.csv')

# names(df)

# op volgorde van id nummer zetten
df <- df[order(as.numeric(df$identifier)), ]

# Initialize lists to store results
unique_in_earlier <- list()
unique_in_later <- list()
pair_ids <- list()

# Function to extract unique lemmas from two texts
extract_unique_lemmas <- function(text1, text2) {
  lemmas1 <- unlist(strsplit(text1, " "))
  lemmas2 <- unlist(strsplit(text2, " "))
  
  unique_lemmas1 <- setdiff(lemmas1, lemmas2)
  unique_lemmas2 <- setdiff(lemmas2, lemmas1)
  
  return(list(unique_lemmas1 = unique_lemmas1, unique_lemmas2 = unique_lemmas2))
}

# Loop through each pair of consecutive rows
for (i in 1:(nrow(df) - 1)) {
  text1 <- df$content[i]
  text2 <- df$content[i + 1]
  
  ids <- paste(df$identifier[i], df$identifier[i + 1], sep = "_")
  
  unique_lemmas <- extract_unique_lemmas(text1, text2)
  
  pair_ids[[i]] <- ids
  unique_in_earlier[[i]] <- unique_lemmas$unique_lemmas1
  unique_in_later[[i]] <- unique_lemmas$unique_lemmas2
}

# Create a new dataframe with the results
comparison_data <- data.frame(
  pair_ids = unlist(pair_ids),
  unique_in_earlier = sapply(unique_in_earlier, paste, collapse = ", "),
  unique_in_later = sapply(unique_in_later, paste, collapse = ", "),
  stringsAsFactors = FALSE
)

# Display the new dataframe
view(comparison_data)

write.csv(comparison_data, 'unieketokens.csv')






