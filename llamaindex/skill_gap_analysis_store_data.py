# Last amedned: 26th March, 2025

# Objectives:
#           This file reads data from file data_reduced.csv
#           Transforms them into embedding vectors and stores
#           the vectors in chromadb.
#           This file Must be rerun regularly through a cron 
#           job for updation of vector store.


# Notes: 
#           a. The RAG library uses llama_index (para AA.)
#               A special python environment has been created
#           b. llm used here is MistralAI.  (pata BB)
#              (the API needs to be purchased)
#           c. The embedding model is of ollama. (para BB)
#           d. Vector store is chromadb (para DD)
#              (Vector store needs to be updated through cron job.
#           e. Rename and select columns of data in para CC.
#           f. Ollama embediing model is being used.

# Run as:
#       python skill_gap_analysis_store_data.py

#----------- AA. Libraries and modules -----------

# 1.0 SimpleDirectoryReader can also load metadata from a dictionary
#     https://docs.llamaindex.ai/en/stable/module_guides/loading/simpledirectoryreader/
from llama_index.core.readers import SimpleDirectoryReader
from llama_index.readers.file import PagedCSVReader

# 1.1 The Settings is a bundle of commonly used resources used 
#     during the indexing and querying stage in a LlamaIndex workflow/application.
from llama_index.core import Settings


# 1.2 Ollama related
# https://docs.llamaindex.ai/en/stable/examples/embeddings/ollama_embedding/
from llama_index.embeddings.ollama import OllamaEmbedding


# 1.3 Vector store related
import chromadb
from llama_index.core import StorageContext
from llama_index.core import VectorStoreIndex
from llama_index.vector_stores.chroma import ChromaVectorStore

# 1.4 Misc
import os
import pandas as pd



#--------BB. Model related--------------

# 2.0 Define embedding function

                            

embed_model= OllamaEmbedding(
                                    model_name="nomic-embed-text",      # Using foundational model may be overkill
                                    base_url="http://localhost:11434",
                                    #dimensions=512,
                                    #ollama_additional_kwargs={"mirostat": 0},
                                  )

Settings.embed_model = embed_model

# 2.1 Set llm_settings:
#     MistralAI is used here.
#     The _key is obtained from MistralAI
#     pip install llama-index-llms-mistralai

from llama_index.llms.mistralai import MistralAI
llm = MistralAI(api_key="apikey")
Settings.llm = llm

#---------------CC. Read Data -----------------

# 2.2 Get Data:
from llama_index.core import Document

# 2.3 csv file location
file_path = ('/home/ashok/Documents/csvrag/data/data_reduced.csv') # insert the path of the csv file
df = pd.read_csv(file_path)

# 2.4
columns_of_interest = ["Roll_Number","fullName","Gender","BirthDate","age","MBA CGPA","Degree","Specialization","total work experience of the student in months"]
df = df[columns_of_interest]
df = df.rename(columns={"fullName": "Full Name", "age": "Age", "total work experience of the student in months" : "Work Experience"})



#----------------- DD. Create chroma vector store---------

# 3.0 Convert rows of the CSV into Document objects
documents = [Document(text=row.to_string()) for _, row in df.iterrows()]



# 3.1 This creates persistent collection. A folder by name of chromadb
#     is created and below that a chroma.sqlite3 database exists:

databasePath = "/home/ashok/Documents/chroma_db"
chroma_client = chromadb.PersistentClient(path=databasePath)

# 3.2 Check if collection exists. If so delete it.

if 'datastore' in chroma_client.list_collections():
    chroma_client.delete_collection("datastore")
    chroma_collection = chroma_client.create_collection("datastore")  
else:
    # Create collection afresh
    chroma_collection = chroma_client.create_collection("datastore")   


# 3.3 Set up a blank ChromaVectorStore and load in data
vector_store = ChromaVectorStore(chroma_collection=chroma_collection)

# 3.4
storage_context = StorageContext.from_defaults(vector_store=vector_store)

#------------EE. Vectorize abd save now --------------        

# 4.0 Takes docs and storage context:
  

index = VectorStoreIndex.from_documents(
                                         documents,
                                         storage_context=storage_context,
                                         show_progress= False                 # Show progress bar is False
                                        )

################### DONE ###################
