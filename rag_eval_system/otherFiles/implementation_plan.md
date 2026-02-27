# RAG + Evaluation System — Implementation Plan

## Overview

This plan describes the implementation of two integrated Python sub-systems:

1. **RAG Sub-system** — ingests Markdown files, embeds them using Ollama's `bge-m3` model, stores vectors in a local PostgreSQL (`harnal`) database using `pgvector`, and answers user queries strictly from the retrieved context using `llama3.2`.
2. **Evaluation Sub-system** — reads Q&A pairs from a CSV file, feeds questions to the RAG sub-system, then uses `deepseek-r1:latest` as a judge LLM to compare RAG responses against ideal answers across four criteria, and logs results to a file.

All code uses **LlamaIndex** libraries. Ollama runs locally via Docker.

---

## User Review Required

> [!IMPORTANT]
> **PostgreSQL pgvector extension** must be installed in the `harnal` database. The plan assumes it has already been set up. If not, we will need to run `CREATE EXTENSION IF NOT EXISTS vector;` once.

> [!IMPORTANT]
> **Ollama models** `llama3.2`, `bge-m3`, and `deepseek-r1:latest` must already be pulled in the local Docker-hosted Ollama instance.

> [!NOTE]
> The project will be created under `/home/ashok/Documents/rag_eval_system/`. The `dataFolder/` directory inside it should be populated with Markdown ([.md](file:///home/ashok/.gemini/antigravity/brain/61aa3baf-1863-4f25-aded-ad27dc765f5c/task.md)) files before running the RAG ingestion step. A few **sample markdown files** and a **sample `data.csv`** will be created as starter data.

---

## Proposed Changes

### Project Directory Structure

```
/home/ashok/Documents/rag_eval_system/
├── config.py                  # Central configuration
├── rag_system.py              # Sub-system 1: RAG system
├── evaluation_system.py       # Sub-system 2: Evaluation system
├── dataFolder/                # Markdown files to be ingested
│   └── sample_doc.md          # Sample markdown file (starter)
├── data.csv                   # Q&A pairs for evaluation
└── evaluation_results.txt     # Output: evaluation logs (auto-created)
```

---

### Component 1 — Configuration

#### [NEW] [config.py](file:///home/ashok/Documents/rag_eval_system/config.py)

Central config file for all settings:
- Ollama base URL: `http://localhost:11434`
- LLM model: `llama3.2`
- Embedding model: `bge-m3`
- Judge LLM: `deepseek-r1:latest`
- PostgreSQL connection string: `postgresql+psycopg2://harnal:harnal@localhost:5432/harnal`
- Paths: `dataFolder/`, `data.csv`, `evaluation_results.txt`

---

### Component 2 — RAG Sub-system

#### [NEW] [rag_system.py](file:///home/ashok/Documents/rag_eval_system/rag_system.py)

Uses LlamaIndex with:
- `llama_index.llms.ollama.Ollama` for the LLM (llama3.2)
- `llama_index.embeddings.ollama.OllamaEmbedding` for bge-m3
- `llama_index.vector_stores.postgres.PGVectorStore` for pgvector-backed PostgreSQL
- `llama_index.core.SimpleDirectoryReader` to load [.md](file:///home/ashok/.gemini/antigravity/brain/61aa3baf-1863-4f25-aded-ad27dc765f5c/task.md) files from `dataFolder/`
- `llama_index.core.VectorStoreIndex` to build the index

**Key behaviors:**
- `ingest_documents()`: loads [.md](file:///home/ashok/.gemini/antigravity/brain/61aa3baf-1863-4f25-aded-ad27dc765f5c/task.md) files → embeds → stores in PostgreSQL. Idempotent (skips if already indexed or can be forced with `--reingest`).
- `query_rag(question: str) → str`: retrieves relevant chunks from vector store, passes to LLM with a strict system prompt that says *"Answer only using the provided context. If you cannot find the answer in the context, say so."*
- CLI mode: `python rag_system.py --ingest` to ingest, or just run `python rag_system.py` to enter interactive query mode.

---

### Component 3 — Evaluation Sub-system

#### [NEW] [evaluation_system.py](file:///home/ashok/Documents/rag_eval_system/evaluation_system.py)

Uses:
- `pandas` to read `data.csv` (columns: `text`, `question`, `idealAnswer`)
- `rag_system.query_rag()` to get RAG answers for each question
- `llama_index.llms.ollama.Ollama` (deepseek-r1:latest) as the Judge LLM
- A structured judge prompt that instructs deepseek-r1 to classify the comparison under exactly one of **4 criteria**:
  - **Criteria 1**: RAG response and idealAnswer hold the same information.
  - **Criteria 2**: RAG response is missing certain information present in the idealAnswer.
  - **Criteria 3**: RAG response contains all idealAnswer info plus extra info not in idealAnswer.
  - **Criteria 4**: RAG response is deficient AND contains extra information not in idealAnswer.

**Key behaviors:**
- Iterates row-by-row through `data.csv`
- For each row: gets RAG response → builds judge prompt → calls deepseek-r1 → writes/appends to `evaluation_results.txt`
- The results file includes: row number, the question, the RAG response, the ideal answer, the judge's criteria classification, and the judge's explanation.

---

### Component 4 — Sample Data

#### [NEW] [dataFolder/sample_doc.md](file:///home/ashok/Documents/rag_eval_system/dataFolder/sample_doc.md)

A sample markdown document as starter/test data for ingestion.

#### [NEW] [data.csv](file:///home/ashok/Documents/rag_eval_system/data.csv)

Sample CSV with a few rows of `text, question, idealAnswer` based on the sample markdown document, for testing the evaluation pipeline.

---

## Verification Plan

### Automated / CLI Tests

1. **PostgreSQL connectivity test**
   ```bash
   cd /home/ashok/Documents/rag_eval_system
   python -c "from config import PG_CONNECTION_STRING; import psycopg2; conn = psycopg2.connect('dbname=harnal user=harnal password=harnal host=localhost'); print('DB OK'); conn.close()"
   ```

2. **Ollama connectivity test**
   ```bash
   curl http://localhost:11434/api/tags
   ```

3. **Ingestion test**
   ```bash
   cd /home/ashok/Documents/rag_eval_system
   python rag_system.py --ingest
   ```

4. **RAG query test (interactive)**
   ```bash
   cd /home/ashok/Documents/rag_eval_system
   python rag_system.py
   # Then type a question related to the content in dataFolder/
   ```

5. **Evaluation pipeline test**
   ```bash
   cd /home/ashok/Documents/rag_eval_system
   python evaluation_system.py
   # Check evaluation_results.txt afterwards
   ```

### Manual Verification

- After ingestion, verify in PostgreSQL that vectors exist:
  ```sql
  SELECT COUNT(*) FROM data_llamaindex;  -- or similar table name
  ```
- Open `evaluation_results.txt` and review that each entry shows: question, RAG response, ideal answer, criteria classification, and explanation.

---

## Dependencies Required

```bash
pip install llama-index llama-index-llms-ollama llama-index-embeddings-ollama llama-index-vector-stores-postgres psycopg2-binary pandas
```
