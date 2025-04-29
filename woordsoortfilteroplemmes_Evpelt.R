# woordsoortfilter via frog voor ellen 



# Pad naar map met XML-bestanden
pad_naar_xml <- "VPelt_lemmatizedFrog"  # <-- pas dit aan


library(xml2)
library(tidyverse)

process_file <- function(file, ns) {
  xml <- read_xml(file)
  ns <- c(folia = "http://ilk.uvt.nl/folia")
  
  lemma_nodes <- xml_find_all(xml, ".//folia:lemma", ns = ns)
  
  # Filter to lemma nodes that have a corresponding <pos> sibling or nearby node
  filtered <- keep(lemma_nodes, function(lemma) {
    !is.na(xml_find_first(xml_parent(lemma), ".//folia:pos", ns = ns))
  })
  
  # Extract lemmas and corresponding pos
  lemmas <- map_chr(filtered, ~ xml_attr(.x, "class"))
  pos_tags <- map_chr(filtered, function(lemma) {
    pos_node <- xml_find_first(xml_parent(lemma), ".//folia:pos", ns = ns)
    xml_attr(pos_node, "class")
  })
  
  
  # # Fix the XPath query by adding the correct namespace (folia)
  # lemmas <- xml %>%
  #   xml_find_all(".//folia:lemma", ns = c(folia = "http://ilk.uvt.nl/folia")) %>%
  #   xml_attr("class")
  # 
  # pos_tags <- xml %>%
  #   xml_find_all(".//folia:pos", ns = c(folia = "http://ilk.uvt.nl/folia")) %>%
  #   xml_attr("class")
  # 
    # Get identifier from filename
  fname <- basename(file)
  identifier <- stringr::str_extract(fname, "(?<=id)\\d+(?=\\.)")
  
  # Build tidy tibble
  tibble(
    identifier = identifier,
    lemma = lemmas,
    pos = pos_tags
    # pos_head = pos_heads  # Optional: add if needed
  )
}

alle_bestanden <- list.files(pad_naar_xml, pattern = "\\.xml$", full.names = TRUE)
# ns <- c(folia = "http://ilk.uvt.nl/folia")
ns <- xml_ns(read_xml(alle_bestanden[1]))

lemma_df <- map_dfr(alle_bestanden, process_file, ns = ns)

# Bekijk het resultaat
View(lemma_df)
write.csv(lemma_df, 'Froglemmas_evpelt.csv')

lemmafilter <- lemma_df%>%
  filter(str_detect(pos, "^(BW|N|WW|ADJ)"))%>%
  select(-pos)

view(lemmafilter)
write.csv(lemmafilter, 'gefilterdelemmasEvP.csv')



