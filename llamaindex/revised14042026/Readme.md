# LlamaIndex Hands-On Curriculum (`revised14042026`)

A structured collection of hands-on Jupyter notebooks for learning **LlamaIndex** with local **Ollama** models. The notebooks progress from basic LLM interactions and Python `asyncio` fundamentals to agentic workflows, router engines, tool calling, ingestion pipelines, persistent hybrid search (PostgreSQL/pgvector, Qdrant, Elasticsearch), metadata extraction, and **GraphRAG** (with Qdrant and Neo4j).

---

## Table of Contents

1. [Folder Structure](#folder-structure)
2. [Notebook Curriculum](#notebook-curriculum)
   - [Part 1: Foundations & Local LLMs](#part-1-foundations--local-llms)
   - [Part 2: Agents, Routing & Tool Calling](#part-2-agents-routing--tool-calling)
   - [Part 3: Ingestion, Incremental Indexing & Evaluation](#part-3-ingestion-incremental-indexing--evaluation)
   - [Part 4: Production RAG, Vector Stores, Hybrid Search & Metadata](#part-4-production-rag-vector-stores-hybrid-search--metadata)
   - [Part 5: GraphRAG Module (`14.graph_rag/`)](#part-5-graphrag-module-14graph_rag)
   - [Supplementary Vector Store Notebooks](#supplementary-vector-store-notebooks)
3. [Datasets Included](#datasets-included)
4. [Prerequisites & Environment Setup](#prerequisites--environment-setup)
5. [Notes & Tips](#notes--tips)

---

## Folder Structure

```text
revised14042026/
├── 1.ollama_usage.ipynb                 # Local Ollama chat, vision, memory, & structured output
├── 2.litellm_usage.ipynb                # Unified LLM gateway with LiteLLM (sync, streaming, async)
├── 3.SQL_on_pandas.ipynb                # Natural-language querying over Pandas DataFrames
├── 4.asyncio_await.ipynb                # Python asyncio, coroutines, await, and gather() primer
├── 5.basic_agent.ipynb                  # AgentWorkflow, FunctionAgent, tools, & Mirostat concepts
├── 6.Router_Engine_RAM.ipynb            # RouterQueryEngine with in-memory (RAM) storage
├── 6A.Router_Engine_RAM.ipynb           # Duplicate of 6.Router_Engine_RAM.ipynb
├── 6B.Router_Engine_post.ipynb          # RouterQueryEngine backed by PostgreSQL / pgvector
├── 7.Tool_Calling.ipynb                 # FunctionTool, ReActAgent, and auto-retrieval tools
├── 8.Ingestion_pipeline.ipynb           # LlamaIndex IngestionPipeline with PGVectorStore
├── 9.Incrementally_add_files.ipynb      # StorageContext, DocstoreStrategy, & incremental updates
├── 10.question_generator.ipynb          # Synthetic Q&A dataset generation & RelevancyEvaluator
├── 11.Agentic_Workflows.ipynb           # FunctionAgent vs. ReActAgent & Yahoo Finance tools
├── 11.postgres-RAG.ipynb                # End-to-end production RAG patterns with PGVectorStore
├── 11.postgres-III.ipynb                # Code-focused PGVectorStore, hybrid search, & chat engine
├── 12.metadataExtractors.ipynb          # Metadata extractors, splitters, & metadata filtering
├── 13.TextNodes And Metadata.ipynb      # TextNode metadata, Elasticsearch & PGVector hybrid search
├── 14.graph_rag/                        # Complete 4-part GraphRAG student lab (RAM, Qdrant, Neo4j)
│   ├── 1.graphrag_student_tutorial.ipynb
│   ├── 2.graphrag_custom_schema_tutorial.ipynb
│   ├── 3.graphrag_custom_schema_qdrant.ipynb
│   ├── 4.graphrag_custom_schema_neo4j.ipynb
│   ├── data/
│   ├── requirements.txt
│   └── README.md
├── postgres.ipynb                       # Standalone PostgreSQL / pgvector starter
├── postgres-I.ipynb                     # PostgreSQL / pgvector setup & vector store creation
├── postgres-II.ipynb                    # PostgreSQL / pgvector with Supreme Court legal text data
├── qdrant.ipynb                         # Standalone Qdrant dense + BM25 sparse hybrid vector store
├── customers-100.csv                    # Sample tabular dataset for Pandas querying
├── metagpt.pdf                          # MetaGPT research paper used in RAG & router labs
├── sports.pdf                           # Sample PDF document
├── txt_files/                           # Indian Supreme Court & High Court orders/judgments (.txt)
└── README.md
```

---

## Notebook Curriculum

### Part 1: Foundations & Local LLMs

| Notebook | Key Topics Covered |
| :--- | :--- |
| [`1.ollama_usage.ipynb`](./1.ollama_usage.ipynb) | Connecting LlamaIndex to local Ollama (`llama3.2:1b`, `llava:latest`), multi-turn conversations (`SimpleChatEngine`, `ChatMemoryBuffer`), `SimpleChatStore` vs. `PostgresChatStore`, image inputs (`ImageBlock`), and structured outputs. |
| [`2.litellm_usage.ipynb`](./2.litellm_usage.ipynb) | Using `LiteLLM` as a unified adapter across LLM providers (including local Ollama models), streaming responses, and async invocation. |
| [`3.SQL_on_pandas.ipynb`](./3.SQL_on_pandas.ipynb) | Natural-language data analysis over CSV/DataFrames (`customers-100.csv`) using `PandasQueryEngine`. |
| [`4.asyncio_await.ipynb`](./4.asyncio_await.ipynb) | Deep dive into Python concurrency: processes vs. threads vs. `asyncio`, `async`/`await`, `asyncio.gather()`, `nest_asyncio`, and handling blocking calls. |

### Part 2: Agents, Routing & Tool Calling

| Notebook | Key Topics Covered |
| :--- | :--- |
| [`5.basic_agent.ipynb`](./5.basic_agent.ipynb) | Introduction to `AgentWorkflow`, `FunctionAgent`, `FunctionTool`, and sampling concepts (Mirostat, perplexity, temperature, `top_p`). |
| [`6.Router_Engine_RAM.ipynb`](./6.Router_Engine_RAM.ipynb) | `RouterQueryEngine` over `SummaryIndex`, `VectorStoreIndex`, and `NLSQLTableQueryEngine` using `LLMSingleSelector` / `LLMMultiSelector` / `PydanticSingleSelector` with in-memory storage (using `metagpt.pdf`). *(Note: [`6A.Router_Engine_RAM.ipynb`](./6A.Router_Engine_RAM.ipynb) is an identical copy.)* |
| [`6B.Router_Engine_post.ipynb`](./6B.Router_Engine_post.ipynb) | Extends the Router Engine lesson to persist vectors/chat state in **PostgreSQL (`PGVectorStore`)** instead of RAM. |
| [`7.Tool_Calling.ipynb`](./7.Tool_Calling.ipynb) | Defining custom `FunctionTool`s, building a `ReActAgent`, async `gather()` with tools, and creating auto-retrieval tools with `MetadataFilters` over `metagpt.pdf`. |
| [`11.Agentic_Workflows.ipynb`](./11.Agentic_Workflows.ipynb) | Comparing `FunctionAgent`, `ReActAgent`, and `RouterEngine`, and building tool-using agents with `YahooFinanceToolSpec`. |

### Part 3: Ingestion, Incremental Indexing & Evaluation

| Notebook | Key Topics Covered |
| :--- | :--- |
| [`8.Ingestion_pipeline.ipynb`](./8.Ingestion_pipeline.ipynb) | Building reusable `IngestionPipeline`s combining `SentenceSplitter`, Ollama/HuggingFace embeddings, and `PGVectorStore`. |
| [`9.Incrementally_add_files.ipynb`](./9.Incrementally_add_files.ipynb) | Understanding `StorageContext`, `SimpleDocumentStore`, `DocstoreStrategy`, and incrementally adding or updating files without re-indexing everything. |
| [`10.question_generator.ipynb`](./10.question_generator.ipynb) | Automatically generating evaluation questions from documents via `DatasetGenerator` and scoring RAG responses with `RelevancyEvaluator`. |

### Part 4: Production RAG, Vector Stores, Hybrid Search & Metadata

| Notebook | Key Topics Covered |
| :--- | :--- |
| [`11.postgres-RAG.ipynb`](./11.postgres-RAG.ipynb) | Comprehensive production RAG guide: Documents vs. Nodes, multiple ways to build `VectorStoreIndex`, `IngestionCache`, PostgreSQL user/password setup, `PGVectorStore`, hybrid search (`QueryFusionRetriever`), and `CondensePlusContextChatEngine`. |
| [`11.postgres-III.ipynb`](./11.postgres-III.ipynb) | Streamlined, code-focused PostgreSQL/pgvector workflow on the court orders dataset (`txt_files/`), covering hybrid search and `CondensePlusContextChatEngine`. |
| [`12.metadataExtractors.ipynb`](./12.metadataExtractors.ipynb) | `SentenceSplitter` vs. `TokenTextSplitter`, LLM-powered metadata extractors, choosing embedding models (`bge-m3`), and hybrid search vs. `MetadataFilters` (`ExactMatchFilter`) with `TreeSummarize`. |
| [`13.TextNodes And Metadata.ipynb`](./13.TextNodes%20And%20Metadata.ipynb) | Working directly with `TextNode` objects and custom metadata; comparing dense, keyword (BM25), hybrid search, and metadata filtering using **Elasticsearch (`ElasticsearchStore`)** and **PostgreSQL (`PGVectorStore`)**. |

### Part 5: GraphRAG Module (`14.graph_rag/`)

A dedicated 4-notebook GraphRAG lab series with its own detailed documentation in [`14.graph_rag/README.md`](./14.graph_rag/README.md) and [`14.graph_rag/requirements.txt`](./14.graph_rag/requirements.txt):

1. [`1.graphrag_student_tutorial.ipynb`](./14.graph_rag/1.graphrag_student_tutorial.ipynb) — Automatic entity/relation extraction (`SimpleLLMPathExtractor`, RAM) and PyVis visualization.
2. [`2.graphrag_custom_schema_tutorial.ipynb`](./14.graph_rag/2.graphrag_custom_schema_tutorial.ipynb) — Controlled schemas (`SchemaLLMPathExtractor`) and manual `EntityNode`/`Relation` graph construction.
3. [`3.graphrag_custom_schema_qdrant.ipynb`](./14.graph_rag/3.graphrag_custom_schema_qdrant.ipynb) — Custom-schema GraphRAG with persistent **Qdrant** vector storage and `VectorContextRetriever`.
4. [`4.graphrag_custom_schema_neo4j.ipynb`](./14.graph_rag/4.graphrag_custom_schema_neo4j.ipynb) — Custom-schema GraphRAG with persistent **Neo4j** (`Neo4jPropertyGraphStore`) and Cypher querying.

### Supplementary Vector Store Notebooks

| Notebook | Description |
| :--- | :--- |
| [`postgres.ipynb`](./postgres.ipynb) | Minimal starter for `PGVectorStore` dense and hybrid search. |
| [`postgres-I.ipynb`](./postgres-I.ipynb) | Earlier iteration of the PostgreSQL/pgvector setup and indexing walkthrough. |
| [`postgres-II.ipynb`](./postgres-II.ipynb) | Earlier iteration applying `PGVectorStore` to the Supreme Court text files (`txt_files/`). |
| [`qdrant.ipynb`](./qdrant.ipynb) | Standalone example of `QdrantVectorStore` with dense embeddings (`nomic-embed-text`) and sparse BM25 (`Qdrant/bm25`). |

---

## Datasets Included

| Path | Description |
| :--- | :--- |
| [`customers-100.csv`](./customers-100.csv) | 100-row sample customer table (`CustomerId`, `Company`, `City`, `Country`, etc.) used for Pandas natural-language querying. |
| [`metagpt.pdf`](./metagpt.pdf) | The MetaGPT research paper, used in the Router Engine and Tool Calling labs (`6*`, `7`). |
| [`sports.pdf`](./sports.pdf) | Sample PDF document for RAG experiments. |
| [`txt_files/`](./txt_files/) | Six Indian Supreme Court and High Court orders/judgments (`Scorder2.txt`, `SCorder3.txt`, `SCorder4.txt`, `Scorder6.txt`, `Scorder7.txt`, `SCorder8.txt`) used in the PostgreSQL, metadata, and hybrid search notebooks. |
| [`14.graph_rag/data/`](./14.graph_rag/data/) | Four interconnected fictional corporate/investigative documents (`aurora_technologies.txt`, `helios_capital.txt`, `synapse_dynamics.txt`, `project_nexus_investigation.txt`) designed to demonstrate multi-hop GraphRAG reasoning. |

---

## Prerequisites & Environment Setup

### 1. Local Ollama Server & Models

Install [Ollama](https://ollama.com/), ensure the server is running (`ollama serve`), and pull the models you want to use. Across the notebooks, the following models are commonly referenced (you can swap in any locally available model):

```bash
# Chat / Reasoning LLMs (pull the ones you need)
ollama pull llama3.2:latest
ollama pull llama3.2:1b
ollama pull llama3.2:3b-instruct-q8_0
ollama pull qwen2.5:latest
ollama pull qwen3:latest

# Vision model (for image cells in 1.ollama_usage.ipynb)
ollama pull llava:latest

# Embedding models
ollama pull nomic-embed-text:latest
ollama pull bge-m3
```

### 2. Python Dependencies

Install the core LlamaIndex and Ollama packages along with the integrations required by the notebooks you plan to run:

```bash
pip install llama-index-core \
  llama-index-llms-ollama \
  llama-index-embeddings-ollama \
  llama-index-readers-file \
  llama-index-llms-litellm \
  llama-index-experimental \
  llama-index-tools-yahoo-finance \
  llama-index-vector-stores-postgres \
  llama-index-storage-chat-store-postgres \
  llama-index-vector-stores-qdrant \
  llama-index-vector-stores-elasticsearch \
  llama-index-embeddings-huggingface \
  psycopg2-binary sqlalchemy pandas nest_asyncio
```

For the **GraphRAG** module (`14.graph_rag/`), install its dedicated requirements file:

```bash
pip install -r 14.graph_rag/requirements.txt
```

### 3. Optional Backing Services

Only start the services needed for the specific notebooks you are running:

- **PostgreSQL + `pgvector`** *(Notebooks `1`, `6B`, `8`, `9`, `11.postgres-*`, `12`, `13`, `postgres*.ipynb`)*:
  Ensure PostgreSQL is running with the `pgvector` extension enabled and update the connection credentials (`host`, `port`, `user`, `password`, `database`) in the notebook cells to match your local setup.
- **Qdrant** *(`qdrant.ipynb`, `14.graph_rag/3.graphrag_custom_schema_qdrant.ipynb`)*:
  ```bash
  docker run -d --name qdrant -p 6333:6333 -p 6334:6334 qdrant/qdrant
  ```
- **Elasticsearch** *(`13.TextNodes And Metadata.ipynb`)*:
  Run a local Elasticsearch instance (default `http://localhost:9200`) and configure credentials/URL in the notebook.
- **Neo4j + APOC** *(`14.graph_rag/4.graphrag_custom_schema_neo4j.ipynb`)*:
  ```bash
  docker run -d --name neo4j \
    -p 7474:7474 -p 7687:7687 \
    -e NEO4J_AUTH=neo4j/password123 \
    -e NEO4J_PLUGINS='["apoc"]' \
    neo4j:latest
  ```

---

## Notes & Tips

- **Async in Jupyter:** Many LlamaIndex agents, pipelines, and retrievers use `asyncio`. Notebooks include `nest_asyncio.apply()` so async code can run smoothly inside Jupyter's existing event loop.
- **Model Swapping:** Several notebooks list alternative Ollama models in comments (e.g., `qwen3`, `qwen3.5`, `llama3.2`, `granite4.1:3b`, `deepseek-r1:7b`). Update `model=...` to match the models pulled on your machine.
- **Duplicate / Progressive Files:**
  - `6.Router_Engine_RAM.ipynb` and `6A.Router_Engine_RAM.ipynb` are identical; `6B.Router_Engine_post.ipynb` is the PostgreSQL-backed variant.
  - `postgres.ipynb`, `postgres-I.ipynb`, `postgres-II.ipynb`, `11.postgres-III.ipynb`, and `11.postgres-RAG.ipynb` represent progressive iterations of the PostgreSQL/pgvector RAG material; start with [`11.postgres-RAG.ipynb`](./11.postgres-RAG.ipynb) for the most complete guide or [`11.postgres-III.ipynb`](./11.postgres-III.ipynb) for the concise code-only version.
