# Import necessary libraries
import chainlit as cl              # For building chat interfaces
import pandas as pd                # For handling CSV file
import os

# Importing components from llama_index
from llama_index.core import Settings, VectorStoreIndex, StorageContext
from llama_index.readers.file import PagedCSVReader
from llama_index.core.readers import SimpleDirectoryReader
from llama_index.embeddings.ollama import OllamaEmbedding
from llama_index.llms.ollama import Ollama
from llama_index.vector_stores.chroma import ChromaVectorStore
import chromadb                    # Vector database for storing embeddings

# ---------------------------- CONFIGURATION ----------------------------

# Path to the CSV file containing job-related data
CSV_PATH = "Random 480 Records-100125.csv"  # Ensure this file is in the same directory
# Directory to store ChromaDB vector index
CHROMA_PATH = "./chroma_db"
# Name of the collection in ChromaDB
COLLECTION_NAME = "quickstart"

# -------------------------- EMBEDDING & LLM SETUP ----------------------

# Initialize embedding model via Ollama (runs locally)
embed_model = OllamaEmbedding(
    model_name="nomic-embed-text",
    base_url="http://localhost:11434"      # Ollama must be running on this port
)

# Initialize local LLM (e.g., llama3.2) via Ollama
llm = Ollama(
    model="llama3.2:latest",               # You can change to another supported model
    request_timeout=120.0,                 # Max time to wait for a response
    temperature=0.4,                        # Controls randomness in output
    mirostat=0                              # Stability control
)

# Set the embedding model and LLM globally for llama_index
Settings.embed_model = embed_model
Settings.llm = llm

# -------------------------- LOAD & INDEX DATA --------------------------

# Read the CSV file using pandas (for general data access if needed)
data = pd.read_csv(CSV_PATH)

# Load and parse CSV file using LlamaIndex's CSV reader
csv_reader = PagedCSVReader()
reader = SimpleDirectoryReader(input_files=[CSV_PATH], file_extractor={".csv": csv_reader})
docs = reader.load_data()                  # Convert CSV into a list of document-like objects

# ---------------------- INITIALIZE CHROMA VECTOR STORE -----------------

# Create a persistent ChromaDB client
chroma_client = chromadb.PersistentClient(path=CHROMA_PATH)

# Check and delete old collection if it already exists to avoid duplication
if COLLECTION_NAME in [col.name for col in chroma_client.list_collections()]:
    chroma_client.delete_collection(COLLECTION_NAME)

# Create a fresh Chroma collection
chroma_collection = chroma_client.create_collection(COLLECTION_NAME)

# Set up vector store and storage context for indexing
vector_store = ChromaVectorStore(chroma_collection=chroma_collection)
storage_context = StorageContext.from_defaults(vector_store=vector_store)

# Create vector index from loaded documents
index = VectorStoreIndex.from_documents(docs, storage_context=storage_context)

# Generate a query engine from the index for natural language querying
query_engine = index.as_query_engine()

# ---------------------- CHAINLIT CHAT INTERFACE ------------------------

# Called when chat session starts
@cl.on_chat_start
def start():
    # Save the query engine and CSV data to the session state
    cl.user_session.set("query_engine", query_engine)
    cl.user_session.set("data", data)

    # Send welcome message to the user
    cl.Message(content="✅ CSV loaded and indexed! Ask me about job responsibilities for any job title and company.").send()

# Called whenever the user sends a message
@cl.on_message
def main(message: cl.Message):
    query = message.content                     # Get the user's question
    query_engine = cl.user_session.get("query_engine")

    # Use LLM to respond to the user's question based on indexed data
    response = query_engine.query(query)
    cl.Message(content=response.response).send()  # Send the LLM's response

# --------------------------- RUN APP LOCALLY ---------------------------

# This ensures the app runs only when the script is executed directly
if __name__ == "__main__":
    cl.run()    # Launches the Chainlit app

