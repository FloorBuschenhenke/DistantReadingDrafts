#doc2vec ish met BERT

#DistilBERT: A smaller, faster variant of BERT.zou ook nog kunnen

library(reticulate)


import pandas as pd
import numpy as np
import torch
from transformers import BertTokenizer, BertModel
from sklearn.metrics.pairwise import cosine_similarity

# Load the Dutch BERT model and tokenizer
model_name = 'GroNLP/bert-base-dutch-cased'
tokenizer = BertTokenizer.from_pretrained(model_name)
model = BertModel.from_pretrained(model_name)

def get_document_embedding(text, tokenizer, model):
    # Tokenize the input text
    inputs = tokenizer(text, return_tensors='pt', truncation=True, padding=True, max_length=512)
    
    # Get the embeddings
    with torch.no_grad():
        outputs = model(**inputs)
    
    # Mean pooling to get the sentence vector
    embeddings = outputs.last_hidden_state
    attention_mask = inputs['attention_mask']
    input_mask_expanded = attention_mask.unsqueeze(-1).expand(embeddings.size())
    sum_embeddings = torch.sum(embeddings * input_mask_expanded, 1)
    sum_mask = torch.sum(input_mask_expanded, 1)
    mean_embeddings = sum_embeddings / sum_mask

    return mean_embeddings


### data inlezen 

data = pd.read_csv('txt_contents_ruw.csv')

df = pd.DataFrame(data)

# Function to get embeddings for each document in the DataFrame
def get_embeddings(df, tokenizer, model):
    embeddings = []
    for content in df['content']:
        embedding = get_document_embedding(content, tokenizer, model)
        embeddings.append(embedding.squeeze().numpy())
    return embeddings

# Get embeddings for all documents
embeddings = get_embeddings(df, tokenizer, model)

# Add embeddings to the DataFrame
df['embedding'] = embeddings

def calculate_pairwise_similarities(df):
    # Extract embeddings from the DataFrame
    embeddings = np.array(df['embedding'].tolist())
    
    # Compute pairwise cosine similarity
    similarities = cosine_similarity(embeddings)
    
    return similarities

# Create a DataFrame for the similarity matrix with identifiers as labels
similarity_df = pd.DataFrame(similarities, index=df['identifier'], columns=df['identifier'])

# Display the similarity matrix
print("Cosine similarity matrix:")
print(similarity_df)

output_file = 'similarity_matrix.csv'
similarity_df.to_csv(output_file, index=True)




