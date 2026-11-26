# 🎓 Student Lab: Understanding & Querying GraphRAG with LlamaIndex & Ollama

An educational, self-contained lab series designed for students to understand **GraphRAG (Graph Retrieval-Augmented Generation)** — progressing from automatic in-memory graph extraction to custom schemas, persistent **Qdrant** vector storage, and persistent **Neo4j** graph storage using local **Ollama** models.

---

## 📖 Table of Contents
1. [What is GraphRAG?](#-what-is-graphrag)
2. [GraphRAG vs. Knowledge RAG vs. Property Graph](#-graphrag-vs-knowledge-rag-vs-property-graph)
3. [Why Traditional Vector RAG Fails (The Multi-Hop Problem)](#-why-traditional-vector-rag-fails)
4. [The Demo Dataset: The Quantum Robotics Consortium](#-the-demo-dataset)
5. [Project Structure & Lab Notebooks](#-project-structure--lab-notebooks)
6. [Quickstart & Environment Setup](#-quickstart--environment-setup)
   - [1. Local Ollama Models](#1-local-ollama-models)
   - [2. Python Dependencies](#2-python-dependencies)
   - [3. Qdrant Docker (for Notebook 3)](#3-qdrant-docker-for-notebook-3)
   - [4. Neo4j Docker with APOC (for Notebook 4)](#4-neo4j-docker-with-apoc-for-notebook-4)
7. [Storage Backend Comparison](#-storage-backend-comparison)
8. [Example Queries & Student Exercises](#-example-queries--student-exercises)
9. [Real-World Use Cases for GraphRAG](#-real-world-use-cases-for-graphrag)
10. [References & Further Reading](#-references--further-reading)

---

## 🧠 What is GraphRAG?

**GraphRAG** combines **Knowledge Graphs** with Large Language Models.

Instead of treating documents solely as flat chunks embedded into a vector space, GraphRAG parses unstructured text into **entities** (e.g., *people*, *companies*, *technologies*) and **relationships** (e.g., *CO_FOUNDED*, *INVESTED_IN*, *LICENSES_TO*), forming a connected network:

$$\text{(Subject Entity)} \xrightarrow{\quad \text{Predicate / Relation} \quad} \text{(Object Entity)}$$

```text
 (Dr. Elena Vance) ──[CO_FOUNDED]──► (Aurora Tech) ◄──[SERVES_ON_BOARD_OF]── (Julian Mercer)
                                                                                    │
                                                                               [WORKS_AT]
                                                                                    ▼
 (Project Nexus) ◄──[TESTBED_FOR]── (Synapse Dynamics) ◄──[INVESTED_IN]── (Helios Capital)
```

---

## 🔍 GraphRAG vs. Knowledge RAG vs. Property Graph

These three terms are closely related and often confused, but they refer to different layers of the stack:

- **Property Graph *(Data Model / Storage Structure)*:**  
  A graph data model (used by **Neo4j** and LlamaIndex's `PropertyGraphIndex`) where **nodes** have labels (e.g., `PERSON`, `COMPANY`) and key–value properties (e.g., `founded: 2021`), and directed **relationships** also have types (e.g., `INVESTED_IN`) and key–value properties (e.g., `amount: "$30M"`, `equity: "15%"`). Compared to plain `(Subject, Predicate, Object)` triples, a Property Graph stores much richer metadata directly on nodes and edges.

- **Knowledge RAG / KG-RAG *(Retrieval Pattern over Structured Facts)*:**  
  A RAG pattern that grounds an LLM using facts retrieved from a **Knowledge Graph** (whether stored as RDF triples or a Property Graph). At query time, it typically looks up matching entities or runs a structured query (like Cypher or SPARQL) to pull exact factual triples into the LLM prompt.

- **GraphRAG *(Full Hybrid Retrieval & Reasoning Architecture)*:**  
  The broader end-to-end RAG architecture that combines **graph traversal** with **vector similarity search** (and, in frameworks like Microsoft GraphRAG, hierarchical community summaries) to answer both **local multi-hop questions** across documents and **global sensemaking questions** over an entire corpus.

| Concept | What It Is | Core Focus | Example in This Lab |
| :--- | :--- | :--- | :--- |
| **Property Graph** | Data model / database structure | Storing labeled nodes, directed edges, and key–value properties | `EntityNode` & `Relation` stored in `SimplePropertyGraphStore` or **Neo4j** |
| **Knowledge RAG (KG-RAG)** | Fact-grounded RAG technique | Querying structured entities & triples (e.g., Cypher / entity lookup) | Querying the manual graph in Notebook 2 (`include_text=False`) or Cypher in Notebook 4 |
| **GraphRAG** | End-to-end hybrid RAG architecture | Combining vector search (`Qdrant` / embeddings) + multi-hop graph traversal + source text synthesis | `PropertyGraphIndex` with `VectorContextRetriever` + `include_text=True` in Notebooks 1–4 |

> **In short:** A **Property Graph** is *how the data is modeled and stored*, **Knowledge RAG** is *retrieving structured facts from a knowledge graph*, and **GraphRAG** is *the complete hybrid system combining graph traversal, vector search, and LLM synthesis*.

---

## ❌ Why Traditional Vector RAG Fails

Traditional Vector RAG splits documents into chunks, embeds them, and retrieves the top-$K$ chunks closest to the query in vector space.

### The Blind Spot: Multi-Hop Reasoning
Consider this question:
> *"How is Dr. Elena Vance connected to Synapse Dynamics and Project Nexus through Helios Capital?"*

- **`aurora_technologies.txt`** states: *Dr. Elena Vance co-founded Aurora Technologies.*
- **`helios_capital.txt`** states: *Helios Capital invested in Aurora Technologies and Synapse Dynamics, and covertly funded Project Nexus.*
- **`synapse_dynamics.txt`** states: *Synapse Dynamics is the primary physical testbed for Project Nexus and appointed Dr. Elena Vance as advisor.*

No single chunk contains the full chain. **GraphRAG** bridges these documents by traversing the extracted relationship edges and combining graph context with vector retrieval.

---

## 📁 The Demo Dataset

The dataset in [`data/`](./data) contains four interconnected text documents:

| Document | Key Information |
|---|---|
| [`aurora_technologies.txt`](./data/aurora_technologies.txt) | Quantum computing startup founded by Dr. Elena Vance and Marcus Thorne; CryoQubit patents; Aether Labs joint venture. |
| [`helios_capital.txt`](./data/helios_capital.txt) | Deep tech venture firm (Victoria Sterling, Julian Mercer, Sofia Chen); investments in Aurora, Aether Labs, Synapse, and covert funding of Project Nexus. |
| [`synapse_dynamics.txt`](./data/synapse_dynamics.txt) | Humanoid robotics firm founded by Dr. Kenji Sato; Elena Vance as Chief Scientific Advisor; primary testbed for Project Nexus. |
| [`project_nexus_investigation.txt`](./data/project_nexus_investigation.txt) | Whistleblower report revealing the covert consortium linking Aurora, Helios, and Synapse, plus an FTC regulatory inquiry. |

---

## 📂 Project Structure & Lab Notebooks

```text
graph_rag/
├── data/
│   ├── aurora_technologies.txt
│   ├── helios_capital.txt
│   ├── synapse_dynamics.txt
│   └── project_nexus_investigation.txt
├── 1.graphrag_student_tutorial.ipynb         # Lab 1: Automatic extraction (SimpleLLMPathExtractor, RAM)
├── 2.graphrag_custom_schema_tutorial.ipynb   # Lab 2: Custom schema & manual EntityNode/Relation (RAM)
├── 3.graphrag_custom_schema_qdrant.ipynb     # Lab 3: Custom schema + persistent Qdrant vector store
├── 4.graphrag_custom_schema_neo4j.ipynb      # Lab 4: Custom schema + persistent Neo4j graph database
├── requirements.txt                          # Python dependencies for all 4 notebooks
└── README.md
```

### Recommended Learning Order
1. **[`1.graphrag_student_tutorial.ipynb`](./1.graphrag_student_tutorial.ipynb)** — Introduces `PropertyGraphIndex` with `SimpleLLMPathExtractor` (the LLM freely decides entities and relations), PyVis HTML graph visualization, and multi-hop querying.
2. **[`2.graphrag_custom_schema_tutorial.ipynb`](./2.graphrag_custom_schema_tutorial.ipynb)** — Shows two ways to control your graph:
   - **Approach 1:** `SchemaLLMPathExtractor` with strict `Literal` entity/relation types and `kg_validation_schema`.
   - **Approach 2:** Fully manual, deterministic graph construction using `EntityNode` and `Relation`.
3. **[`3.graphrag_custom_schema_qdrant.ipynb`](./3.graphrag_custom_schema_qdrant.ipynb)** — Replaces the default in-memory `SimpleVectorStore` (RAM) with a persistent **Qdrant** vector database running in Docker, including persisting & reloading without re-extraction and fast single-LLM-call retrieval via `VectorContextRetriever`.
4. **[`4.graphrag_custom_schema_neo4j.ipynb`](./4.graphrag_custom_schema_neo4j.ipynb)** — Replaces the in-memory `SimplePropertyGraphStore` with a persistent **Neo4j** graph database (`Neo4jPropertyGraphStore`), supporting both schema-guided extraction and manual upserts plus direct Cypher queries.

---

## 🚀 Quickstart & Environment Setup

### 1. Local Ollama Models
Start Ollama and pull the LLM and embedding models used across the notebooks:
```bash
ollama serve
ollama pull qwen2.5:latest
ollama pull nomic-embed-text:latest
```

### 2. Python Dependencies
```bash
pip install -r requirements.txt
```

### 3. Qdrant Docker (for Notebook 3)
```bash
docker run -d --name qdrant \
  -p 6333:6333 -p 6334:6334 \
  -v $(pwd)/qdrant_storage:/qdrant/storage \
  qdrant/qdrant
```
- Qdrant Web Dashboard: **http://localhost:6333/dashboard**

### 4. Neo4j Docker with APOC (for Notebook 4)
> LlamaIndex's `Neo4jPropertyGraphStore` requires the **APOC** plugin (`NEO4J_PLUGINS='["apoc"]'`).

```bash
docker run -d --name neo4j \
  -p 7474:7474 -p 7687:7687 \
  -v $(pwd)/neo4j_data:/data \
  -e NEO4J_AUTH=neo4j/password123 \
  -e NEO4J_PLUGINS='["apoc"]' \
  neo4j:latest
```
- Neo4j Browser UI: **http://localhost:7474** (username: `neo4j`, password: `password123`)
- Stop / start later: `docker stop neo4j` and `docker start neo4j`

> [!TIP]
> **Jupyter Async Tip:** All notebooks apply `nest_asyncio.apply()` and pass `use_async=False` to `PropertyGraphIndex` and `as_query_engine()` to avoid nested event loop and `sniffio` errors inside Jupyter.

---

## 🗄️ Storage Backend Comparison

| Notebook | Graph Store | Vector Store | Persists Across Restarts? |
| :--- | :--- | :--- | :--- |
| **1. `1.graphrag_student_tutorial.ipynb`** | `SimplePropertyGraphStore` (RAM) | `SimpleVectorStore` (RAM) | No |
| **2. `2.graphrag_custom_schema_tutorial.ipynb`** | `SimplePropertyGraphStore` (RAM) | `SimpleVectorStore` (RAM) | No |
| **3. `3.graphrag_custom_schema_qdrant.ipynb`** | `SimplePropertyGraphStore` (Disk JSON) | **Qdrant (Docker)** | Yes |
| **4. `4.graphrag_custom_schema_neo4j.ipynb`** | **Neo4j (Docker + APOC)** | **Neo4j Native Vector Index** | Yes |

---

## 📝 Example Queries & Student Exercises

### Example Multi-Hop Questions
1. *"How is Dr. Elena Vance connected to Synapse Dynamics and Project Nexus through Helios Capital?"*
2. *"Who funded Project Nexus and which company serves as its testbed?"*
3. *"Which executives and companies are being scrutinized by the Federal Trade Commission?"*

### Suggested Exercises
1. **Expand the Corpus:** Add a new file `data/senate_hearing.txt` and re-run Notebook 2 or 4 to see how the schema constrains newly extracted nodes and edges.
2. **Strict vs. Soft Schemas:** Toggle `strict=False` in `SchemaLLMPathExtractor` and compare the extracted triplets against `strict=True`.
3. **Cypher Exploration:** In Notebook 4 (or at `http://localhost:7474`), write a Cypher query to find shortest paths between `Dr. Elena Vance` and `Project Nexus`.

---

## 🌍 Real-World Use Cases for GraphRAG

GraphRAG is most valuable whenever **the connections between documents matter as much as the text inside them**.

### Case Study: Analyzing Court Judgments & Legal Jurisprudence
Law is naturally a **directed, evolving graph** of statutes, cases, courts, and precedents — making legal analysis one of the strongest real-world fits for a custom-schema Property Graph (such as Neo4j in Notebook 4):

- **Avoiding the "Overruled Precedent" Trap:** Standard Vector RAG retrieves text purely by semantic similarity and can return an outdated ruling without knowing a later bench overruled it. An explicit `(Case_2024) --[OVERRULES]--> (Case_2018)` edge immediately flags whether a precedent is still good law.
- **Tracing Statutory Interpretation Over Time:** Questions like *"How has Section X been interpreted across High Courts and the Supreme Court?"* require multi-hop traversal across many judgments rather than isolated chunk retrieval.
- **Rich Legal Metadata:** Property Graphs store `court_level`, `bench_size`, `year`, `jurisdiction`, and `holding` directly on nodes and edges for structured filtering.

**Example Legal Schema:**
- **Node Types:** `CASE`, `STATUTE`, `SECTION`, `COURT`, `JUDGE`, `LEGAL_PRINCIPLE`
- **Relationship Types:** `INTERPRETS`, `CITES`, `FOLLOWS`, `DISTINGUISHES`, `OVERRULES`, `UPHOLDS`, `STRIKES_DOWN`, `DECIDED_BY`, `PART_OF`

```text
(Case A [2018]) ──[INTERPRETS {stance: "broad"}]──► (Section 66A) ──[PART_OF]──► (IT Act, 2000)
       ▲
   [OVERRULES]
       │
(Case B [2024]) ──[DECIDED_BY {bench: "5-Judge"}]──► (Supreme Court)
```

> **Practical Tip:** In legal GraphRAG, **entity resolution** (normalizing `"Sec. 498A IPC"`, `"Section 498A"`, and `"s. 498A of the Indian Penal Code"` into a single canonical node) is critical so all judgments connect to the same statutory section.

### Other High-Value Domains
1. **Financial Forensics, Fraud & AML Compliance:** Uncovering hidden ownership chains, shell companies, shared directors, and layered transactions across corporate filings and bank records.
2. **Biomedical & Clinical Research:** Linking `Gene → Protein → Biological Pathway → Disease → Drug → Side Effect` across scientific papers to discover drug interactions or repurposing candidates.
3. **Supply Chain & Enterprise Impact Analysis:** Tracing multi-tier dependencies (`Raw Material → Tier-2 Supplier → Component → Product → Customer SLA`) to assess disruption blast radius.
4. **Cybersecurity & Threat Intelligence:** Connecting `Threat Actor → Malware → CVE Vulnerability → Affected Service → Host` across logs to trace attack paths.
5. **Regulatory & Policy Compliance:** Mapping `Regulation → Clause → Internal Policy → System / Department` to see the downstream impact when a rule changes.
6. **Codebase Architecture & Root-Cause Analysis:** Modeling `Service → API → Database Table → Incident Ticket` to trace cascading failures across microservices.

> **When to stick with plain Vector RAG:** For straightforward single-document Q&A (e.g., searching an HR FAQ or product manual where cross-document relationships do not matter), standard Vector RAG is usually simpler and faster.

---

## 📚 References & Further Reading

### Foundational Research Papers
- **From Local to Global: A Graph RAG Approach to Query-Focused Summarization** — Darren Edge et al., Microsoft Research (2024): [arXiv:2404.16130](https://arxiv.org/abs/2404.16130)
- **Graph Retrieval-Augmented Generation: A Survey** — Boci Peng et al. (2024): [arXiv:2408.08921](https://arxiv.org/abs/2408.08921)
- **Unifying Large Language Models and Knowledge Graphs: A Roadmap** — Shirui Pan et al. (2023): [arXiv:2306.08302](https://arxiv.org/abs/2306.08302)

### Framework & Tool Documentation (Used in This Lab)
- **LlamaIndex — Property Graph Index Guide:** [docs.llamaindex.ai/en/stable/module_guides/indexing/lpg_index_guide/](https://docs.llamaindex.ai/en/stable/module_guides/indexing/lpg_index_guide/)
- **LlamaIndex — Neo4j Property Graph Store Example:** [docs.llamaindex.ai/en/stable/examples/property_graph/property_graph_neo4j/](https://docs.llamaindex.ai/en/stable/examples/property_graph/property_graph_neo4j/)
- **LlamaIndex — Qdrant Vector Store Example:** [docs.llamaindex.ai/en/stable/examples/vector_stores/QdrantIndexDemo/](https://docs.llamaindex.ai/en/stable/examples/vector_stores/QdrantIndexDemo/)
- **Qdrant Vector Database Documentation:** [qdrant.tech/documentation/](https://qdrant.tech/documentation/)
- **Neo4j Cypher Manual:** [neo4j.com/docs/cypher-manual/current/](https://neo4j.com/docs/cypher-manual/current/)
- **Neo4j APOC Plugin Documentation:** [neo4j.com/docs/apoc/current/](https://neo4j.com/docs/apoc/current/)
- **Ollama (Local LLMs & Embeddings):** [ollama.com](https://ollama.com/)

### Open-Source Projects & Free Learning Courses
- **Microsoft GraphRAG (Official Repository):** [github.com/microsoft/graphrag](https://github.com/microsoft/graphrag)
- **Neo4j GraphAcademy (Free Courses on Cypher, Knowledge Graphs & GraphRAG):** [graphacademy.neo4j.com](https://graphacademy.neo4j.com/)


