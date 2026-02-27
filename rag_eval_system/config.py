"""
Location: /home/ashok/Documents/rag_eval_system/
config.py
Central configuration for the RAG + Evaluation system.
"""

import os

# ─────────────────────────────────────────────
# Ollama settings  (Docker-hosted Ollama)
# ─────────────────────────────────────────────
OLLAMA_BASE_URL = "http://192.240.1.27:11434"

LLM_MODEL       = "llama3.2"           # RAG answering LLM
EMBED_MODEL      = "nomic-embed-text"             # Embedding model
JUDGE_LLM_MODEL  = "deepseek-r1:latest" # Evaluation judge LLM

# ─────────────────────────────────────────────
# PostgreSQL / pgvector settings
# ─────────────────────────────────────────────
PG_HOST     = "192.240.1.27"
PG_PORT     = 5432
PG_DB       = "ashok"
PG_USER     = "ashok"
PG_PASSWORD = "ashok"

# LlamaIndex PGVectorStore uses a plain connection string
PG_CONNECTION_STRING = (
    f"postgresql+psycopg2://{PG_USER}:{PG_PASSWORD}"
    f"@{PG_HOST}:{PG_PORT}/{PG_DB}"
)

# Table name used by PGVectorStore to persist vectors
PG_TABLE_NAME = "rag_vectors"

# ─────────────────────────────────────────────
# File / directory paths
# ─────────────────────────────────────────────
BASE_DIR         = os.path.dirname(os.path.abspath(__file__))
DATA_FOLDER      = os.path.join(BASE_DIR, "dataFolder")
EVAL_CSV         = os.path.join(BASE_DIR, "data.csv")
EVAL_RESULTS     = os.path.join(BASE_DIR, "evaluation_results.txt")

# ─────────────────────────────────────────────
# LLM / query settings
# ─────────────────────────────────────────────
LLM_TEMPERATURE        = 0.1   # Low temperature → deterministic RAG answers
JUDGE_LLM_TEMPERATURE  = 0.0   # Very deterministic judge
REQUEST_TIMEOUT        = 300.0 # seconds – increase if models are slow
SIMILARITY_TOP_K       = 5     # number of context chunks to retrieve
