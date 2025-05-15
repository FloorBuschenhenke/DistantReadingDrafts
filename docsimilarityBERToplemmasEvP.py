import pandas as pd
import numpy as np
import torch
from transformers import BertTokenizer, BertModel
from sklearn.metrics.pairwise import cosine_similarity

# Load the Dutch BERT model and tokenizer
model_name = 'GroNLP/bert-base-dutch-cased'
tokenizer = BertTokenizer.from_pretrained(model_name)
model = BertModel.from_pretrained(model_name)

# Functie om documentembedding te berekenen met mean pooling
def get_document_embedding(text, tokenizer, model):
    inputs = tokenizer(text, return_tensors='pt', truncation=True, padding=True, max_length=512)

    with torch.no_grad():
        outputs = model(**inputs)

    embeddings = outputs.last_hidden_state
    attention_mask = inputs['attention_mask']
    input_mask_expanded = attention_mask.unsqueeze(-1).expand(embeddings.size())
    sum_embeddings = torch.sum(embeddings * input_mask_expanded, 1)
    sum_mask = torch.sum(input_mask_expanded, 1)
    mean_embeddings = sum_embeddings / sum_mask

    return mean_embeddings

# Lees de data in
df = pd.read_csv('uniekelemmasEVP.csv')

# Genereer embeddings voor de 'unique_in_earlier' en 'unique_in_later' kolommen
def get_embeddings(df, tokenizer, model):
    hidden_size = model.config.hidden_size  # meestal 768 voor BERT-base

    def safe_embedding(text):
        if not isinstance(text, str) or text.strip() == "":
            return np.zeros(hidden_size)
        return get_document_embedding(text, tokenizer, model).squeeze().numpy()

    earlier_embeddings = []
    later_embeddings = []

    for _, row in df.iterrows():
        earlier_embeddings.append(safe_embedding(row['unique_in_earlier']))
        later_embeddings.append(safe_embedding(row['unique_in_later']))

    return earlier_embeddings, later_embeddings

# Cosine similarity berekenen tussen de twee sets embeddings
def compute_cosine_similarities(earlier_embeddings, later_embeddings):
    similarities = []
    for e1, e2 in zip(earlier_embeddings, later_embeddings):
        if np.linalg.norm(e1) == 0 or np.linalg.norm(e2) == 0:
            similarities.append(0.0)
        else:
            sim = cosine_similarity([e1], [e2])[0][0]
            similarities.append(sim)
    return similarities

# Bereken en sla cosine similarity op
earlier_embeds, later_embeds = get_embeddings(df, tokenizer, model)
similarities = compute_cosine_similarities(earlier_embeds, later_embeds)
df['cosine_similarity'] = similarities

# Exporteer de resultaten naar een CSV-bestand
similarity_df = df[['pair_ids']].copy()
similarity_df['cosine_similarity'] = similarities
similarity_df.to_csv("similarity_output_lemmasEvP.csv", index=False)





