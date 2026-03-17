# RAG System — Walkthrough

## What Was Built

A complete Retrieval-Augmented Generation (RAG) system using LangChain, Ollama, and PostgreSQL/pgvector.

| Component | Detail |
|-----------|--------|
| LLM | `llama3.2` via Ollama @ `192.240.1.27:11434` |
| Embeddings | `nomic-embed-text` via Ollama (768-dim vectors) |
| Vector Store | PostgreSQL `gautam` DB — pgvector collection `rag_documents` |
| Chunk size | 500 tokens, 50 overlap |
| Retrieval | Top-4 similarity search |

---

## File Structure

```
/home/ashok/simplerag/
├── ingest.py                    # Embed & store markdown docs
├── rag_query.py                 # Retrieve context + generate grounded answer
├── main.py                      # Interactive CLI entry point
└── dataFolder/
    ├── machine_learning_basics.md
    ├── python_data_science.md
    └── deep_learning.md
```

---

## How to Run

```bash
source /home/ashok/langchain/bin/activate
cd /home/ashok/simplerag
```

### Step 1 — Ingest documents
```bash
python ingest.py
```
This loads all [.md](file:///home/ashok/simplerag/dataFolder/deep_learning.md) files from `dataFolder/`, splits them into chunks, embeds them with `nomic-embed-text`, and stores the vectors in PostgreSQL. Re-running it safely clears and recreates the collection.

### Step 2 — Query
```bash
python rag_query.py "Your question here"
```
Or pass no argument for an interactive prompt.

### Or use the interactive CLI
```bash
python main.py
```
This provides a menu: ingest, query, or both in sequence.

---

## Test Results

### ✅ Ollama Connectivity
```
Embedding dim: 768, first 5 values: [-0.006, -0.001, -0.171, 0.008, 0.005]
Ollama embedding: OK
```

### ✅ Ingestion
```
[ingest] Loaded 3 document(s).
[ingest] Split into 23 chunk(s).
[ingest] ✓ Ingestion complete. 23 chunk(s) stored in collection 'rag_documents'.
```

### ✅ In-domain query — grounded answer
**Query:** *"What are the different types of machine learning and their examples?"*

Retrieved context from 4 relevant chunks (ML basics + deep learning docs), then produced an answer grounded strictly in those chunks.

### ✅ Out-of-domain query — safe fallback
**Query:** *"What is the capital city of France?"*

Correctly responded:
> **"I don't know based on the provided documents."**

The LLM did not hallucinate or pull from its pre-training knowledge.

---

## Adding Your Own Documents

1. Drop [.md](file:///home/ashok/simplerag/dataFolder/deep_learning.md) files into `dataFolder/`
2. Re-run `python ingest.py` to re-embed everything
3. Query as normal
