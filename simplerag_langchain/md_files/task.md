# RAG System Task Checklist

## Planning
- [x] Explore workspace and understand requirements
- [x] Check installed Python packages
- [x] Verify PostgreSQL + pgvector setup
- [x] Write implementation plan

## Execution
- [x] Create `dataFolder/` directory with sample markdown files
- [x] Write [ingest.py](file:///home/ashok/simplerag/ingest.py) — reads markdown files, embeds them, stores in PostgreSQL
- [x] Write [rag_query.py](file:///home/ashok/simplerag/rag_query.py) — takes user query, retrieves context from PG, generates answer via Ollama LLM
- [x] Write [main.py](file:///home/ashok/simplerag/main.py) — interactive CLI entry point combining ingest + query
- [x] Install any missing packages (all already present)

## Verification
- [/] Test Ollama connectivity (embedding + LLM)
- [ ] Test ingest pipeline (embed & store vectors)
- [ ] Test RAG query (retrieve context + generate answer)
- [ ] End-to-end smoke test with sample query
