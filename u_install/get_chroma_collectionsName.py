import chromadb
client = chromadb.PersistentClient(path="/home/ashok/Documents/data/")
collections = client.list_collections()
print("Collections are:", collections)
