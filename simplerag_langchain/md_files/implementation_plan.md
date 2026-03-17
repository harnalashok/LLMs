# RAG System — Implementation Plan

Build a Retrieval-Augmented Generation (RAG) system using LangChain, Ollama models, and PostgreSQL (pgvector) as the vector store. The system ingests local Markdown files, stores their vector embeddings, and answers user queries strictly from the stored context.

## Environment Summary
| Component | Value |
|-----------|-------|
| LLM | `llama3.2` via Ollama |
| Embeddings | `nomic-embed-text` via Ollama |
| Ollama host | `http://192.240.1.27:11434` |
| Vector store | PostgreSQL (`gautam` DB, user `gautam`, password `gautam`) |
| pgvector | v0.8.1 (already installed) |
| Python env | `/home/ashok/langchain` venv |
| Source docs | `dataFolder/*.md` |

---

## Proposed Changes

### Core Scripts

#### [NEW] [ingest.py](file:///home/ashok/simplerag/ingest.py)
- Loads all `*.md` files from `dataFolder/` using `DirectoryLoader` + `UnstructuredMarkdownLoader`
- Splits text into chunks with `RecursiveCharacterTextSplitter` (chunk_size=500, overlap=50)
- Embeds chunks with `OllamaEmbeddings(model="nomic-embed-text")`
- Stores vectors in PostgreSQL using `PGVector` from `langchain_community.vectorstores`
- Connection string: `postgresql+psycopg2://gautam:gautam@localhost:5432/gautam`
- Collection name: `rag_documents`
- Can be re-run safely (clears and recreates the collection)

#### [NEW] [rag_query.py](file:///home/ashok/simplerag/rag_query.py)
- Loads `OllamaEmbeddings` + `OllamaLLM` (`llama3.2`)
- Connects to PGVector store (same connection string)
- Builds a retriever (top-k=4 similar chunks)
- Constructs a custom `ChatPromptTemplate` that instructs the LLM to answer **only from the provided context** and to say "I don't know" if the answer isn't in the context
- Formats and prints: retrieved **context chunks** and the final **answer**
- Accepts a query string as argument or via interactive prompt

#### [NEW] [main.py](file:///home/ashok/simplerag/main.py)
- Interactive CLI: prompts user to either ingest documents or run a query
- Calls functions from `ingest.py` and `rag_query.py`

#### [NEW] [dataFolder/](file:///home/ashok/simplerag/dataFolder/) (sample markdown files)
- 2–3 sample `.md` files covering different topics to demonstrate the RAG capability

---

## Verification Plan

### Automated Tests
Run each command from the `simplerag` directory with the venv activated:

```bash
source /home/ashok/langchain/bin/activate
cd /home/ashok/simplerag
```

1. **Test Ollama connectivity**
   ```bash
   python -c "from langchain_ollama import OllamaEmbeddings; e = OllamaEmbeddings(model='nomic-embed-text', base_url='http://192.240.1.27:11434'); print(e.embed_query('hello')[:5])"
   ```

2. **Test ingest pipeline**
   ```bash
   python ingest.py
   ```
   Expected: Prints number of chunks embedded and "Ingestion complete".

3. **Test RAG query**
   ```bash
   python rag_query.py "What is discussed in the documents?"
   ```
   Expected: Prints context chunks retrieved from PostgreSQL, then a grounded answer from `llama3.2`.

4. **Interactive mode**
   ```bash
   python main.py
   ```
   Expected: Interactive prompt allowing repeated queries.
