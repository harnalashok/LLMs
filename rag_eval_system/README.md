# RAG + Evaluation System
# Location: /home/ashok/Documents/rag_eval_system/

An integrated Retrieval-Augmented Generation (RAG) system and evaluation pipeline built with **LlamaIndex**, **Ollama** (local Docker), and **PostgreSQL pgvector**.

---

## Project Structure

```
rag_eval_system/
├── config.py               # Central configuration (URLs, models, DB settings)
├── rag_system.py           # Sub-system 1: RAG ingestion & query
├── evaluation_system.py    # Sub-system 2: Automated RAG evaluation
├── dataFolder/             # Place your .md files here for ingestion
│   ├── space_exploration.md    (sample)
│   └── ai_fundamentals.md      (sample)
├── data.csv                # Q&A pairs for evaluation (text, question, idealAnswer)
└── evaluation_results.txt  # Auto-created; evaluation output is appended here
```

---

## Setup

### 1. Install dependencies (one-time)
```bash
pip install llama-index llama-index-llms-ollama llama-index-embeddings-ollama \
            llama-index-vector-stores-postgres psycopg2-binary pandas
```

### 2. Verify Ollama is running
```bash
curl http://192.240.1.27:11434/api/tags
```
Ensure `llama3.2`, `bge-m3`, and `deepseek-r1:latest` are listed.

### 3. Verify PostgreSQL
```bash
psql -U harnal -d harnal -c "SELECT extname FROM pg_extension WHERE extname='vector';"
```
Should return `vector`.

---

## Sub-system 1: RAG System (`rag_system.py`)

### Ingest markdown files
```bash
cd /home/ashok/Documents/rag_eval_system
python rag_system.py --ingest
```

### Re-ingest (drop existing vectors first)
```bash
python rag_system.py --ingest --reset
```

### Interactive query mode
```bash
python rag_system.py
```

### Single query
```bash
python rag_system.py --query "Who was the first human in space?"
```

---

## Sub-system 2: Evaluation System (`evaluation_system.py`)

### Run evaluation (uses `data.csv` by default)
```bash
cd /home/ashok/Documents/rag_eval_system
python evaluation_system.py
```

### Use a custom CSV file
```bash
python evaluation_system.py --csv /path/to/your_questions.csv
```

### CSV Format
```
text,question,idealAnswer
"context text","Your question here","The ideal answer here"
```

### Evaluation Output
Results are appended to `evaluation_results.txt`. Each entry includes:
- The question
- RAG response
- Ideal answer
- Judge LLM evaluation (Criteria 1–4)
- Judge's analysis and justification

---

## Evaluation Criteria

| Criteria | Meaning |
|----------|---------|
| **1** | RAG response matches the ideal answer exactly |
| **2** | RAG response is missing information from the ideal answer |
| **3** | RAG response contains ideal answer info + extra information |
| **4** | RAG response is both deficient and contains extra information |

---

## Configuration (`config.py`)

| Setting | Default | Description |
|---------|---------|-------------|
| `OLLAMA_BASE_URL` | `http://192.240.1.27:11434` | Ollama Docker host |
| `LLM_MODEL` | `llama3.2` | RAG answering LLM |
| `EMBED_MODEL` | `bge-m3` | Embedding model |
| `JUDGE_LLM_MODEL` | `deepseek-r1:latest` | Evaluation judge |
| `PG_DB` | `harnal` | PostgreSQL database |
| `PG_TABLE_NAME` | `rag_vectors` | Vector store table |
| `SIMILARITY_TOP_K` | `5` | Context chunks retrieved per query |

---

## Adding Your Own Documents

1. Place your `.md` files inside the `dataFolder/` directory.
2. Run the ingestion command:
   ```bash
   python rag_system.py --ingest --reset
   ```
   The `--reset` flag clears existing vectors for a fresh ingest.

## Adding Your Own Evaluation Data

Edit or replace `data.csv`. The file must have these three columns:
- `text` — source passage (optional context, not used by the RAG engine directly)
- `question` — question to be given to the RAG system
- `idealAnswer` — ground-truth answer for the judge to compare against
