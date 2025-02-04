# Python program to  empty chromadb collection
#  ie empty all vectors without deleting the collection
# Use as:
#         python3 empty_chromadb.py

import chromadb
from time import sleep

print("Will empty documents from a collection.")
print("We assume only one collection:")
sleep(8)

client = chromadb.PersistentClient(path="/home/ashok/Documents/data/")
collections = client.list_collections()
col = client.get_or_create_collection(collections[0])
col.get()
col.delete(col.get()["ids"]) 
