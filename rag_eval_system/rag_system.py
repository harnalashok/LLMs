"""
rag_system.py
Sub-system 1 — RAG pipeline using LlamaIndex, Ollama, and PostgreSQL pgvector.
Location: /home/ashok/Documents/rag_eval_system/

Usage:
  python rag_system.py --ingest          # Ingest / re-ingest markdown files
  python rag_system.py --ingest --reset  # Drop existing vectors, re-ingest
  python rag_system.py                   # Interactive query mode
  python rag_system.py --query "..."     # Single query mode
"""

import argparse
import sys
import os

from llama_index.core import (
    Settings,
    SimpleDirectoryReader,
    StorageContext,
    VectorStoreIndex,
)
from llama_index.core.prompts import PromptTemplate
from llama_index.llms.ollama import Ollama
from llama_index.embeddings.ollama import OllamaEmbedding
from llama_index.vector_stores.postgres import PGVectorStore

import psycopg2
from psycopg2 import sql

import config

# ─────────────────────────────────────────────
# 1. Configure global LlamaIndex Settings
# ─────────────────────────────────────────────

def configure_settings():
    """Set global LLM and embedding model for LlamaIndex."""
    Settings.llm = Ollama(
        model=config.LLM_MODEL,
        base_url=config.OLLAMA_BASE_URL,
        temperature=config.LLM_TEMPERATURE,
        request_timeout=config.REQUEST_TIMEOUT,
    )
    Settings.embed_model = OllamaEmbedding(
        model_name=config.EMBED_MODEL,
        base_url=config.OLLAMA_BASE_URL,
    )


# ─────────────────────────────────────────────
# 2. Build / connect the PGVectorStore
# ─────────────────────────────────────────────

def get_vector_store(reset: bool = False) -> PGVectorStore:
    """
    Return a PGVectorStore instance connected to the ashok database.
    If reset=True, the existing table is dropped so documents can be
    re-ingested from scratch.
    """
    if reset:
        # Drop the table so we start fresh
        conn = psycopg2.connect(
            dbname=config.PG_DB,
            user=config.PG_USER,
            password=config.PG_PASSWORD,
            host=config.PG_HOST,
            port=config.PG_PORT,
        )
        conn.autocommit = True
        with conn.cursor() as cur:
            cur.execute(
                sql.SQL("DROP TABLE IF EXISTS {} CASCADE").format(
                    sql.Identifier("data_" + config.PG_TABLE_NAME)
                )
            )
            print(f"[INFO] Dropped existing table 'data_{config.PG_TABLE_NAME}'.")
        conn.close()

    vector_store = PGVectorStore.from_params(
        database=config.PG_DB,
        host=config.PG_HOST,
        password=config.PG_PASSWORD,
        port=str(config.PG_PORT),
        user=config.PG_USER,
        table_name=config.PG_TABLE_NAME,
        embed_dim=768,   # bge-m3 produces 1024-dimensional embeddings
    )
    return vector_store


# ─────────────────────────────────────────────
# 3. Ingest documents
# ─────────────────────────────────────────────

def ingest_documents(reset: bool = False):
    """
    Read all Markdown files from dataFolder, embed them with bge-m3,
    and store the vectors in PostgreSQL.
    """
    data_folder = config.DATA_FOLDER
    if not os.path.isdir(data_folder):
        print(f"[ERROR] dataFolder not found: {data_folder}")
        sys.exit(1)

    md_files = [f for f in os.listdir(data_folder) if f.endswith(".md")]
    if not md_files:
        print(f"[WARN] No .md files found in {data_folder}. Exiting.")
        sys.exit(0)

    print(f"[INFO] Found {len(md_files)} markdown file(s): {md_files}")

    # Load documents
    documents = SimpleDirectoryReader(
        input_dir=data_folder,
        required_exts=[".md"],
        recursive=True,
    ).load_data()
    print(f"[INFO] Loaded {len(documents)} document chunk(s).")

    # Prepare vector store and storage context
    vector_store = get_vector_store(reset=reset)
    storage_context = StorageContext.from_defaults(vector_store=vector_store)

    # Build index — this embeds all documents and stores them in PG
    print("[INFO] Embedding documents and storing in PostgreSQL … (this may take a while)")
    VectorStoreIndex.from_documents(
        documents,
        storage_context=storage_context,
        show_progress=True,
    )
    print("[INFO] ✅ Ingestion complete. Vectors stored in PostgreSQL.")


# ─────────────────────────────────────────────
# 4. Build query engine
# ─────────────────────────────────────────────

# Strict RAG prompt — the LLM MUST answer only from provided context
_RAG_PROMPT_TMPL = (
    "You are a helpful assistant. Answer the question ONLY using the "
    "information provided in the context below. Do NOT use any knowledge "
    "from your pre-training or outside the provided context.\n"
    "If the context does not contain enough information to answer the "
    "question, say: 'I do not have enough information in the provided "
    "documents to answer this question.'\n\n"
    "---------------------\n"
    "Context:\n"
    "{context_str}\n"
    "---------------------\n"
    "Question: {query_str}\n"
    "Answer:"
)
_RAG_PROMPT = PromptTemplate(_RAG_PROMPT_TMPL)


def build_query_engine():
    """
    Connect to existing vectors in PostgreSQL and return a query engine
    that restricts answers to retrieved context only.
    """
    vector_store = get_vector_store(reset=False)
    index = VectorStoreIndex.from_vector_store(vector_store=vector_store)
    query_engine = index.as_query_engine(
        similarity_top_k=config.SIMILARITY_TOP_K,
        text_qa_template=_RAG_PROMPT,
    )
    return query_engine


def query_rag(question: str) -> str:
    """
    Public API used by evaluation_system.py.
    Returns the RAG sub-system's string answer for the given question.
    """
    engine = build_query_engine()
    response = engine.query(question)
    return str(response).strip()


# ─────────────────────────────────────────────
# 5. CLI entry point
# ─────────────────────────────────────────────

def main():
    parser = argparse.ArgumentParser(
        description="RAG Sub-system (LlamaIndex + Ollama + PostgreSQL pgvector)"
    )
    parser.add_argument(
        "--ingest",
        action="store_true",
        help="Ingest markdown files from dataFolder into the vector store.",
    )
    parser.add_argument(
        "--reset",
        action="store_true",
        help="Used with --ingest: drop existing vectors before re-ingesting.",
    )
    parser.add_argument(
        "--query",
        type=str,
        default=None,
        help="Run a single query and exit.",
    )
    args = parser.parse_args()

    configure_settings()

    if args.ingest:
        ingest_documents(reset=args.reset)
        return

    # Query mode
    if args.query:
        answer = query_rag(args.query)
        print(f"\n[RAG Answer]\n{answer}\n")
        return

    # Interactive mode
    print("=" * 60)
    print("  RAG Query System  (type 'exit' or 'quit' to stop)")
    print("=" * 60)
    while True:
        try:
            question = input("\nYour question: ").strip()
        except (KeyboardInterrupt, EOFError):
            print("\n[INFO] Exiting.")
            break
        if question.lower() in {"exit", "quit", "q"}:
            break
        if not question:
            continue
        print("\n[INFO] Querying RAG …")
        answer = query_rag(question)
        print(f"\n[RAG Answer]\n{answer}\n")


if __name__ == "__main__":
    main()
