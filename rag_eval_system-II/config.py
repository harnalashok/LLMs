"""
config.py — Shared configuration constants for the RAG + Evaluation system.
"""

import os

# ── Ollama ────────────────────────────────────────────────────────────────────
OLLAMA_BASE_URL   = "http://192.240.1.27:11434"
LLM_MODEL         = "llama3.2"
EMBED_MODEL       = "nomic-embed-text"
JUDGE_LLM_MODEL   = "deepseek-r1:latest"

# ── PostgreSQL ────────────────────────────────────────────────────────────────
PG_USER     = "gautam"
PG_PASSWORD = "gautam"
PG_HOST     = "localhost"
PG_PORT     = 5432
PG_DB       = "gautam"

# Postgres table / schema for the vector store
PG_TABLE_NAME  = "rag_embeddings"
PG_SCHEMA_NAME = "public"
EMBED_DIM      = 768          # nomic-embed-text output dimension

# ── Paths ─────────────────────────────────────────────────────────────────────
BASE_DIR     = os.path.dirname(os.path.abspath(__file__))
DATA_FOLDER  = os.path.join(BASE_DIR, "dataFolder")
DATA_CSV     = os.path.join(BASE_DIR, "data.csv")
EVAL_RESULTS = os.path.join(BASE_DIR, "evaluation_results.csv")
