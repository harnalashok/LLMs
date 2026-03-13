"""
rag_system.py — Sub-system 1: RAG Pipeline

Uses:
  - Ollama LLM (llama3.2) and embedding model (nomic-embed-text) at 192.240.1.27
  - PostgreSQL (pgvector) as vector store  
  - LlamaIndex for indexing and querying
"""

import logging
import psycopg2

from llama_index.core import (
    SimpleDirectoryReader,
    StorageContext,
    VectorStoreIndex,
    Settings,
)
from llama_index.core.node_parser import SentenceSplitter
from llama_index.llms.ollama import Ollama
from llama_index.embeddings.ollama import OllamaEmbedding
from llama_index.vector_stores.postgres import PGVectorStore

from config import (
    OLLAMA_BASE_URL,
    LLM_MODEL,
    EMBED_MODEL,
    PG_USER,
    PG_PASSWORD,
    PG_HOST,
    PG_PORT,
    PG_DB,
    PG_TABLE_NAME,
    PG_SCHEMA_NAME,
    EMBED_DIM,
    DATA_FOLDER,
)

logging.basicConfig(level=logging.INFO, format="%(asctime)s [%(levelname)s] %(message)s")
logger = logging.getLogger(__name__)

# ── System prompt: restrict LLM to retrieved context only ─────────────────────
SYSTEM_PROMPT = (
    "You are a helpful assistant. Answer the user's question ONLY using the "
    "information provided in the context below. Do NOT use any knowledge from "
    "your pre-training. If the answer cannot be found in the provided context, "
    "respond with: 'I don't know based on the available documents.'\n\n"
    "Be concise, accurate, and cite the relevant part of the context when possible."
)


# ── Helpers ───────────────────────────────────────────────────────────────────

def _build_connection_string() -> str:
    return (
        f"postgresql+psycopg2://{PG_USER}:{PG_PASSWORD}"
        f"@{PG_HOST}:{PG_PORT}/{PG_DB}"
    )


def _ensure_pgvector_extension() -> None:
    """Ensure the pgvector extension is installed in the target database."""
    logger.info("Ensuring pgvector extension exists in database '%s'...", PG_DB)
    conn = psycopg2.connect(
        dbname=PG_DB, user=PG_USER, password=PG_PASSWORD, host=PG_HOST, port=PG_PORT
    )
    conn.autocommit = True
    with conn.cursor() as cur:
        cur.execute("CREATE EXTENSION IF NOT EXISTS vector;")
    conn.close()
    logger.info("pgvector extension is ready.")


def _configure_global_settings() -> None:
    """Set global LlamaIndex LLM and embedding model."""
    Settings.llm = Ollama(
        model=LLM_MODEL,
        base_url=OLLAMA_BASE_URL,
        request_timeout=300.0,
        system_prompt=SYSTEM_PROMPT,
    )
    Settings.embed_model = OllamaEmbedding(
        model_name=EMBED_MODEL,
        base_url=OLLAMA_BASE_URL,
        request_timeout=120.0,
    )
    Settings.node_parser = SentenceSplitter(chunk_size=512, chunk_overlap=50)
    logger.info("Global LlamaIndex settings configured (LLM=%s, Embed=%s).", LLM_MODEL, EMBED_MODEL)


def _build_vector_store() -> PGVectorStore:
    """Create and return a PGVectorStore connected to the PostgreSQL database."""
    return PGVectorStore.from_params(
        database=PG_DB,
        host=PG_HOST,
        password=PG_PASSWORD,
        port=str(PG_PORT),
        user=PG_USER,
        table_name=PG_TABLE_NAME,
        schema_name=PG_SCHEMA_NAME,
        embed_dim=EMBED_DIM,
    )


# ── Public API ────────────────────────────────────────────────────────────────

def ingest() -> int:
    """
    Read all markdown files from DATA_FOLDER, embed them, and store in PostgreSQL.

    Returns:
        Number of nodes (chunks) stored.
    """
    _ensure_pgvector_extension()
    _configure_global_settings()

    logger.info("Reading documents from: %s", DATA_FOLDER)
    documents = SimpleDirectoryReader(
        input_dir=DATA_FOLDER,
        required_exts=[".md"],
        recursive=True,
    ).load_data()
    logger.info("Loaded %d document(s).", len(documents))

    vector_store = _build_vector_store()
    storage_context = StorageContext.from_defaults(vector_store=vector_store)

    logger.info("Embedding and ingesting documents into PostgreSQL...")
    index = VectorStoreIndex.from_documents(
        documents,
        storage_context=storage_context,
        show_progress=True,
    )
    logger.info("Ingestion complete.")
    return len(documents)


def load_index() -> VectorStoreIndex:
    """
    Load an existing index from the PostgreSQL vector store (no re-ingestion).

    Returns:
        VectorStoreIndex backed by the PostgreSQL vector store.
    """
    _configure_global_settings()
    vector_store = _build_vector_store()
    storage_context = StorageContext.from_defaults(vector_store=vector_store)
    index = VectorStoreIndex.from_vector_store(
        vector_store=vector_store,
        storage_context=storage_context,
    )
    logger.info("Index loaded from PostgreSQL vector store.")
    return index


def query_rag(question: str, index: VectorStoreIndex = None, similarity_top_k: int = 4) -> dict:
    """
    Query the RAG system with a user question.

    Args:
        question:         The user question string.
        index:            Optional pre-loaded VectorStoreIndex. Loaded lazily if not provided.
        similarity_top_k: Number of context chunks to retrieve.

    Returns:
        dict with keys:
            'question' : the original question
            'context'  : list of retrieved text chunks (strings)
            'answer'   : the LLM-generated answer grounded in context
    """
    if index is None:
        index = load_index()

    query_engine = index.as_query_engine(
        similarity_top_k=similarity_top_k,
        response_mode="compact",
    )

    logger.info("Querying RAG system: '%s'", question)
    response = query_engine.query(question)

    # Extract source node texts as context
    context_chunks = []
    if response.source_nodes:
        for node in response.source_nodes:
            context_chunks.append(node.node.get_content())

    result = {
        "question": question,
        "context": context_chunks,
        "answer": str(response).strip(),
    }

    logger.info("RAG answer generated (%d context chunks used).", len(context_chunks))
    return result


# ── Standalone test ────────────────────────────────────────────────────────────

if __name__ == "__main__":
    print("=== Standalone RAG Query Test ===")
    test_q = "What is Retrieval-Augmented Generation and how does it reduce hallucinations?"
    result = query_rag(test_q)

    print(f"\n[QUESTION]\n{result['question']}\n")
    print("[CONTEXT CHUNKS RETRIEVED]")
    for i, chunk in enumerate(result["context"], 1):
        print(f"  --- Chunk {i} ---\n  {chunk[:300]}...\n")
    print(f"[ANSWER]\n{result['answer']}\n")
