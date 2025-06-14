# python program to get names of chroma collections
# # Use as:
#         python3 get_chroma_collectionsName.py

import chromadb
client = chromadb.PersistentClient(path="/home/ashok/Documents/data/")
collections = client.list_collections()
print("Collections are:", collections)
