# een sessie geannoteerd (tekst) adhv event-taxonomy vauth et al
## alleen de nieuw toegevoegde zinnen vanaf de tweede sessie dan...
## nu alles gedaan van id0 en id1, en dan verschil berekenen narrativescore (nieuw-oud)
## danwel verwijderde zinnen ook coderen ?

library(tidyverse)

# Define the path to the directory containing the text files
path_to_files <- "eventdata"

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

# Extract the numeric part of all filenames
identifiers <- sapply(file_list, extract_numeric_part)

# Create a data frame with the content and identifiers
data <- data.frame(
  identifier = identifiers,
  content = tolower(unlist(file_contents)),
  stringsAsFactors = FALSE
)

view(data)

write.csv(data, 'txt_events_ruw.csv')


### cijfers tussen [] als
# er niets anders tussen staat, extraheren en tellen om narrativity/eventfullness te meten per sessie
# en dan verschillen tussen sessieversies ook 

# extractevents

data$identifier <- as.numeric(data$identifier)
data2 <- data%>%
  ##vanwege de id0 die eigenlijk id1 is (en verder)
 mutate(identifier2 = identifier+1)%>%
   group_by(identifier2)

data2$nonevent <- str_count(data2$content,'[0]')
data2$stativeevent <- str_count(data2$content, '[2]')
data2$processevent <- str_count(data2$content, '[5]')
data2$changeevent <- str_count(data2$content, '[7]')

view(data2)

data3<- data2%>%
    mutate(narrativescore = sum(stativeevent*2, processevent*5, changeevent*7, na.rm=TRUE))%>%
  ungroup()%>%
    ## this one is the difference between current identifier and previous one, id0 = baseline
  mutate(narrativediff = narrativescore-lag(narrativescore))

view(data3)

write.csv(data3, 'eventcount.csv') 
  
ggplot(data3)+ geom_point(aes(identifier, narrativescore))
  


  ## pair_id maken
  ## waarde laatste - waarde eerste
data3 <- read.csv('eventcount.csv')
df <- data3

df$identifier <- as.numeric(df$identifier)
df <- df[order(as.numeric(df$identifier)), ]


# Generate the new table with consecutive pairs
df_pairs <- df %>%
  ungroup()%>%
  mutate(previous_identifier = lag(identifier2))%>%
  filter(!is.na(previous_identifier)) %>%
  mutate(id_pairs = paste(previous_identifier, identifier2, sep = "_"))%>%
  select(-identifier,-identifier2, -content, -previous_identifier)%>%
  select(id_pairs, everything())
  

 view(df_pairs)

worddif <- df_pairs %>%
  mutate(Pairs_id = case_match(id_pairs, "37_38" ~ "37_40", 
                               .default = id_pairs))%>%
  select(-id_pairs)

wordplot <- worddif %>%
  mutate(Pairs_id = factor(Pairs_id, levels = unique(Pairs_id[order(
    as.numeric(gsub("_.*", "", Pairs_id)),  # Extract first part of pair_ids
    as.numeric(gsub(".*_", "", Pairs_id))   # Extract second part of pair_ids
  )])))













