library(xml2)
library(dplyr)
library(stringr)
library(purrr)

# Pad naar map met XML-bestanden
pad_naar_xml <- "VPelt_lemmatizedFrog"  

# Functie om lemmas uit één bestand te halen
extract_lemmas <- function(file) {
  xml <- read_xml(file)
  
  # Haal namespace info op en geef 'folia' als prefix aan de default namespace
  ns <- xml_ns(xml)
  ns["folia"] <- ns["d1"]  # 'd1' is hoe xml2 de default namespace noemt
  
  # Vind lemma elementen met juiste namespace
  lemmas <- xml %>%
    xml_find_all(".//folia:lemma", ns) %>%
    xml_attr("class")
  
  
  fname <- basename(file)
  identifier <- stringr::str_extract(fname, "(?<=id)\\d+(?=.)")
  
  tibble(
    identifier = identifier,
    content = paste(lemmas, collapse = " ")
  )
}
  



  
# Verwerk alle bestanden in map
alle_bestanden <- list.files(pad_naar_xml, pattern = "\\.xml$", full.names = TRUE)
lemma_df <- map_dfr(alle_bestanden, extract_lemmas)

# Bekijk het resultaat
View(lemma_df)

write.csv(lemma_df, 'Froglemmas_evpelt.csv')







