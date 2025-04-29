### galahad en frog lemmatizers uitproberen
# udpipe was niet heel goed nl.


### test Galahad lemmatizer op id4 en id5

# inlezen tsv files

library(xml2)
library(tidyverse)

# Define the path to the directory containing the text files

files <- list.files(path = "Jente4_5_galahadParser", pattern = "\\.tsv$", full.names = TRUE)

# Function to extract the final numeric part of a filename
extract_numeric_part <- function(file) {
  base_name <- basename(file)       # Get file name without path
  base_name <- sub("\\.tsv$", "", base_name)  # Remove .tsv extension
  numeric_part <- sub(".*[^0-9]([0-9]+)$", "\\1", base_name)  # Extract final numeric part
  return(numeric_part)
}

# Extract identifiers
identifiers <- sapply(files, extract_numeric_part)

# Read and combine files with identifiers
data_list <- mapply(function(file, id) {
  df <- read.delim(file, header = TRUE, sep = "\t")
  df$Identifier <- id  # Add identifier column
  return(df)
}, files, identifiers, SIMPLIFY = FALSE)

# Combine all dataframes into one
final_data <- do.call(rbind, data_list)

# View the final dataframe
View(final_data)

# op volgorde van id nummer zetten

final_data <- final_data %>%
   select(lemma, Identifier)

final_data <- final_data[order(as.numeric(final_data$Identifier)), ]

final_data <- final_data %>%
  group_by(lemma) %>%
  mutate(
    unique_in_4 = ifelse(all(Identifier == 4), lemma, NA),
    unique_in_5 = ifelse(all(Identifier == 5), lemma, NA)
  ) %>%
  ungroup()

View(final_data)

summary_table <- final_data %>%
  summarize(
    unique_in_4 = paste(na.omit(unique(unique_in_4)), collapse = ", "),
    unique_in_5 = paste(na.omit(unique(unique_in_5)), collapse = ", ")
  )

View(summary_table)
write.csv(summary_table,'galahad_4_5_lemmas.csv')


### ook met Frog ###
# # Pad naar map met XML-bestanden
# pad_naar_xml <- "Jente_lemmatizedFrog"  # <-- pas dit aan
#
# # Functie om lemmas uit één bestand te halen
# extract_lemmas <- function(file) {
#   xml <- read_xml(file)
#
#   # Haal namespace info op en geef 'folia' als prefix aan de default namespace
#   ns <- xml_ns(xml)
#   ns["folia"] <- ns["d1"]  # 'd1' is hoe xml2 de default namespace noemt
#
#   # Vind lemma elementen met juiste namespace
#   lemmas <- xml %>%
#     xml_find_all(".//folia:lemma", ns) %>%
#     xml_attr("class")
#
#
#   fname <- basename(file)
#   identifier <- stringr::str_extract(fname, "(?<=ID)\\d+(?=\\.)")
#
#   tibble(
#     identifier = identifier,
#     lemma = paste(lemmas, collapse = " ")
#   )
# }
#
#
# # Verwerk alle bestanden in map
# alle_bestanden <- list.files(pad_naar_xml, pattern = "\\.xml$", full.names = TRUE)
# lemma_df <- map_dfr(alle_bestanden, extract_lemmas)
#
# # Bekijk het resultaat
# View(lemma_df)
#
# write.csv(lemma_df, 'Froglemmas_Jente.csv')

final_data <- lemma_df %>%
  select(lemma, identifier)

final_data <- final_data[order(as.numeric(final_data$identifier)), ]

final_data <- final_data%>%
  separate_rows(lemma, sep = " ")

view(final_data)

final_data <- final_data %>%
  group_by(lemma) %>%
  mutate(
    unique_in_4 = ifelse(all(identifier == 4), lemma, NA),
    unique_in_5 = ifelse(all(identifier == 5), lemma, NA)
  ) %>%
  ungroup()

View(final_data)

summary_table <- final_data %>%
  summarize(
    unique_in_4 = paste(na.omit(unique(unique_in_4)), collapse = ", "),
    unique_in_5 = paste(na.omit(unique(unique_in_5)), collapse = ", ")
  )

View(summary_table)
write.csv(summary_table,'frog_4_5_lemmas.csv')



