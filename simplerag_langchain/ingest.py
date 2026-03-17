"""
ingest.py
---------
Reads all Markdown files from `dataFolder/`, splits them into chunks,
embeds them with nomic-embed-text via Ollama, and stores the vectors
in the PostgreSQL (pgvector) collection `rag_documents`.
"""

import os
from langchain_community.document_loaders import DirectoryLoader, TextLoader
from langchain_text_splitters import RecursiveCharacterTextSplitter
from langchain_ollama import OllamaEmbeddings
from langchain_community.vectorstores import PGVector

# ──────────────────────────────────────────────────────────────────────────────
# Configuration
# ──────────────────────────────────────────────────────────────────────────────
OLLAMA_BASE_URL = "http://192.240.1.27:11434"
EMBEDDING_MODEL = "nomic-embed-text"

PG_CONNECTION_STRING = "postgresql+psycopg2://gautam:gautam@localhost:5432/gautam"
COLLECTION_NAME = "rag_documents"

DATA_FOLDER = os.path.join(os.path.dirname(__file__), "dataFolder")

CHUNK_SIZE = 500
CHUNK_OVERLAP = 50


def load_documents(folder: str):
    """Load all .md files from the given folder."""
    print(f"[ingest] Loading documents from: {folder}")
    loader = DirectoryLoader(
                            folder,
                            glob="**/*.md",
                            loader_cls=TextLoader,
                            loader_kwargs={"encoding": "utf-8"},
                            show_progress=True,
                            )
    docs = loader.load()
    print(f"[ingest] Loaded {len(docs)} document(s).")
    return docs


def split_documents(docs):
    """Split documents into smaller chunks."""
    splitter = RecursiveCharacterTextSplitter(
                                            chunk_size=CHUNK_SIZE,
                                            chunk_overlap=CHUNK_OVERLAP,
                                            separators=["\n\n", "\n", " ", ""],
                                         )
    chunks = splitter.split_documents(docs)
    print(f"[ingest] Split into {len(chunks)} chunk(s).")
    return chunks


def get_embeddings():
    """Return the Ollama embedding model."""
    return OllamaEmbeddings(
                            model=EMBEDDING_MODEL,
                            base_url=OLLAMA_BASE_URL,
                           )


def ingest():
    """Full ingestion pipeline: load → split → embed → store."""
    docs = load_documents(DATA_FOLDER)
    if not docs:
        print("[ingest] No documents found in dataFolder/. Aborting.")
        return

    chunks = split_documents(docs)
    embeddings = get_embeddings()

    print(f"[ingest] Connecting to PostgreSQL and storing vectors …")
    # PGVector.from_documents drops and recreates the collection each time,
    # ensuring a clean, up-to-date vector store on every ingest run.
    vectorstore = PGVector.from_documents(
                                        documents=chunks,
                                        embedding=embeddings,
                                        collection_name=COLLECTION_NAME,
                                        connection_string=PG_CONNECTION_STRING,
                                        pre_delete_collection=True,   # wipe old data before re-ingesting
    )
    print(f"[ingest] ✓ Ingestion complete. {len(chunks)} chunk(s) stored in "
          f"collection '{COLLECTION_NAME}'.")
    return vectorstore


if __name__ == "__main__":
    ingest()
