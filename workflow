workflow

lemmatizen.R = 
het inlezen van de map oefendata (begonnen met elke5esessie_data dat was begin- en eindversies van werksessie van jente. telkens sprongen van 5 genomen, dus sessie 0, sessie 5, sessie 10. laatste is sessie 35. en de gepubliceerde versie (met nr 40, maar is niet gelogd)). nu staan in oefendata de eindsessies van alle sessies (ongefilterd, zitten missch wat valse starts tussen.)

de txt plus naam van versie staat in 'txt_contents_ruw.csv'
daarna met udpipe gelemmatized, output staat in 'lemmas.csv'

uniekelemmas.r=
op basis van lemmas.csv per versie-paar de unieke lemmas vinden.
output is 'uniekelemmas.csv'

tokens.R =
udpipe op ruwe data gebruikt om tabel met per versie alleen alle tokens te krijgen
output is 'tokenized.csv'

unieketokens.r=
vergelijkbare procedure met uniekelemmas. input is tokenized.csv
output is 'unieketokens.csv'
dat is dus lijstjes met woorden

lemmasentokens.R=
tellen van aantal unieke lemmas en woorden per paar versies, 
- relatieve verschillen tussen aantal lemmas en aantal tokens te zien in tabel 'df'
(daar staan ook nog de lijstjes van de tokens en lemmas zelf in)
staafdiagrammen van zowel tokens als lemmas los

documentlengte.R = woorden tellen per file en ggplot maken

docsimilarityBERT.py=
op basis van text 'txt_contents_ruw.csv' een soort doc2vec ('pairwise cosine similarity') uitgevoerd met de dutch bert
output is similarity_matrix.csv

similaritymatrix.R =
neemt de output van de py-file en ipv alle versie met alle versies selecteert ie alleen dezelfde paren als de token en lemma files, dus 0-1 , 1-2 etc. ook plaatje van de similarity per paar

woordsoortfilteroplemmas.R = 
alleen nouns, adj, adv en verbs genomen van de lemmas om de hoogste semantische ladingen te krijgen. output is 'gefilterdelemmas.csv'

docsimilarityBERToplemmas.py =
vervolg van woordsoortfilter
output is 'similarity_matrix_lemmas.csv'

levenshtein.R =
lev distance tussen alle paren van sessies. 
output is levenshteindistances.csv




