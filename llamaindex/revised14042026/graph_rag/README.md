# 🎓 Student Lab: Understanding & Querying GraphRAG with LlamaIndex & Ollama

An educational, self-contained project designed for students to understand **GraphRAG (Graph Retrieval-Augmented Generation)**, how Knowledge Graphs are constructed from unstructured text, and how graph traversal answers complex multi-hop questions that traditional Vector RAG fails to solve.

---

## 📖 Table of Contents
1. [What is GraphRAG?](#-what-is-graphrag)
2. [Why Traditional Vector RAG Fails (The Multi-Hop Problem)](#-why-traditional-vector-rag-fails)
3. [How GraphRAG Works Step-by-Step](#-how-graphrag-works-step-by-step)
4. [The Demo Dataset: The Quantum Robotics Consortium](#-the-demo-dataset)
5. [Project Architecture](#-project-architecture)
6. [Quickstart Guide](#-quickstart-guide)
   - [Option A: Immediate Offline Demo (Zero Setup / GPU-Free)](#option-a-instant-offline-demo-zero-setup)
   - [Option B: Live Pipeline with Local Ollama](#option-b-live-pipeline-with-local-ollama)
7. [Querying the Graph](#-querying-the-graph)
8. [Interactive Knowledge Graph Visualizer](#-interactive-knowledge-graph-visualizer)
9. [Student Exercises & Lab Assignments](#-student-exercises--lab-assignments)

---

## 🧠 What is GraphRAG?

**GraphRAG** combines the power of **Knowledge Graphs** with Large Language Models. 

Instead of treating documents solely as flat chunks embedded into a vector space, GraphRAG parses unstructured text into **entities** (e.g., *people*, *organizations*, *technologies*) and **relationships** (e.g., *co-founded*, *invested in*, *licensed to*), forming a connected network:

$$\text{(Subject Entity)} \xrightarrow{\quad \text{Predicate / Relation} \quad} \text{(Object Entity)}$$

```
 (Dr. Elena Vance) ──[CO_FOUNDED]──► (Aurora Tech) ◄──[BOARD_MEMBER]── (Julian Mercer)
                                                                             │
                                                                   [INVESTMENT_DIR]
                                                                             ▼
 (Project Nexus) ◄──[TESTBED_FOR]── (Synapse Dynamics) ◄──[INVESTED_IN]── (Helios Capital)
```

---

## ❌ Why Traditional Vector RAG Fails

Traditional Vector RAG performs **semantic similarity matching**:
1. It splits documents into chunks.
2. It embeds each chunk into a high-dimensional vector.
3. For a given user query, it retrieves the top-$K$ chunks closest in cosine similarity.

### The Blind Spot: Multi-Hop Reasoning
Consider this question:
> *"How is Dr. Elena Vance connected to Synapse Dynamics and Project Nexus through Helios Capital?"*

- **Document A** mentions: *Dr. Elena Vance founded Aurora Technologies.*
- **Document B** mentions: *Helios Capital director Julian Mercer holds a board seat at Aurora Technologies and invested in Synapse Dynamics.*
- **Document C** mentions: *Synapse Dynamics is testing Project Nexus.*

None of these chunks alone mentions all three entities! 
- **Naive Vector RAG** retrieves isolated snippets and concludes: *"There is no stated connection between Dr. Elena Vance and Synapse Dynamics."*
- **GraphRAG** traverses the relationship edges across the knowledge graph, linking the three documents together seamlessly!

---

## ⚙️ How GraphRAG Works Step-by-Step

```
┌─────────────────┐       ┌──────────────────────┐       ┌────────────────────────┐
│  Raw Documents  │ ───►  │  LLM Extraction      │ ───►  │ Property Graph Index   │
│  (.txt files)   │       │  (Entities & Triples)│       │ (Nodes + Edges + Embed)│
└─────────────────┘       └──────────────────────┘       └───────────┬────────────┘
                                                                     │
                                                                     ▼
┌─────────────────┐       ┌──────────────────────┐       ┌────────────────────────┐
│ Synthesized     │ ◄───  │ Graph Traversal      │ ◄───  │ Student User Query     │
│ Final Answer    │       │ + Subgraph Retrieval │       │ "How is X linked to Y?"│
└─────────────────┘       └──────────────────────┘       └────────────────────────┘
```

1. **Chunking**: Input text is divided into manageable segments.
2. **Entity & Relation Extraction**: LlamaIndex prompts Ollama to detect named entities and relational verbs.
3. **Graph Construction**: Entities become graph **Nodes**; relationships become directed **Edges**.
4. **Hybrid Retrieval**: When a query arrives, LlamaIndex:
   - Identifies key entities in the question.
   - Retrieves connected subgraphs (1-hop, 2-hop, or multi-hop paths).
   - Combines vector text chunks with graph relationships.
5. **Synthesis**: The LLM receives both the structural graph context and raw text to synthesize a comprehensive answer.

---

## 📁 The Demo Dataset

The dataset in [`data/`](./data) models an investigative technology consortium:

| Document | Key Information |
|---|---|
| [`aurora_technologies.txt`](./data/aurora_technologies.txt) | Quantum computing startup founded by Dr. Elena Vance and Marcus Thorne; CryoQubit patents. |
| [`helios_capital.txt`](./data/helios_capital.txt) | Deep tech venture fund led by Julian Mercer; investments in Aurora, Aether Labs, and Synapse. |
| [`synapse_dynamics.txt`](./data/synapse_dynamics.txt) | Humanoid robotics company founded by Dr. Kenji Sato; appoints Elena Vance as advisor. |
| [`project_nexus_investigation.txt`](./data/project_nexus_investigation.txt) | Whistleblower memo exposing covert integration of quantum chips into military reconnaissance robots. |

---

## 📂 Project Architecture

```
graphrag_student_demo/
├── data/                                # Sample interconnected text corpus
│   ├── aurora_technologies.txt
│   ├── helios_capital.txt
│   ├── synapse_dynamics.txt
│   └── project_nexus_investigation.txt
├── output/                              # Generated artifacts
│   ├── knowledge_graph.html             # Drag-and-drop interactive visual graph
│   └── extracted_triples.json           # Machine-readable extracted relations
├── config.py                            # Model, port, and directory configuration
├── visualize_graph.py                   # Graph renderer (Vis.js HTML + NetworkX PNG)
├── mock_demo.py                         # Instant offline demo (no Ollama required)
├── graphrag_demo.py                     # Main LlamaIndex + Ollama pipeline
├── query_cli.py                         # Interactive question-answering terminal
├── graphrag_student_tutorial.ipynb      # Interactive Jupyter notebook for lab class
├── requirements.txt                     # Python dependencies
└── setup.sh                             # Automated environment setup script
```

---

## 🚀 Quickstart Guide

### Option A: Instant Offline Demo (Zero Setup)
Students can run the simulation immediately without installing Ollama or downloading models:

```bash
cd /home/ashok/anomaly_project/graphrag_student_demo
python3 mock_demo.py
```

**What this does:**
1. Loads the 4 documents.
2. Extracts 21 entities and 31 relational triples.
3. Builds an interactive visualization at [`output/knowledge_graph.html`](./output/knowledge_graph.html).
4. Solves the multi-hop path: `Dr. Elena Vance ➔ Aurora Technologies ➔ Helios Capital ➔ Synapse Dynamics ➔ Project Nexus`.

---

### Option B: Live Pipeline with Local Ollama

#### 1. Install & Launch Ollama
If not already installed, download Ollama from [ollama.com](https://ollama.com):
```bash
# In your terminal:
ollama serve
```

Pull the required models:
```bash
# LLM (fast, lightweight instruction-tuned model)
ollama pull llama3.2

# High-performance local text embeddings
ollama pull nomic-embed-text
```

#### 2. Install Project Dependencies
```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

#### 3. Run the Live GraphRAG Pipeline
```bash
python3 graphrag_demo.py
```

This runs LlamaIndex's `PropertyGraphIndex`, automatically extracting entities and edges via Ollama, saving the index into `storage/property_graph/`, and querying it!

#### 4. Interactive Jupyter Lab Notebook
Open [`graphrag_student_tutorial.ipynb`](./graphrag_student_tutorial.ipynb) in JupyterLab, VS Code, or Google Colab.

> [!TIP]
> **Jupyter Notebook Event Loop Tip**: Jupyter kernels already run inside an active `asyncio` event loop. When building `PropertyGraphIndex` in Jupyter, always pass `use_async=False` and apply `nest_asyncio.apply()` to prevent `RuntimeError: asyncio.run() cannot be called from a running event loop`. Both are pre-configured in the notebook.

---

## 💬 Querying the Graph

### Using the Interactive CLI Console
Run the interactive CLI to test your own questions:
```bash
python3 query_cli.py
```

### Example Questions to Try:
1. **Multi-hop reasoning**:
   > *"How is Dr. Elena Vance connected to Synapse Dynamics and Project Nexus through Helios Capital?"*
2. **Regulatory inquiry**:
   > *"Which executives and companies are being scrutinized by the Federal Trade Commission?"*
3. **Intellectual property flow**:
   > *"What technology transfer occurred between Aurora Technologies and Synapse Dynamics?"*

---

## 🌐 Interactive Knowledge Graph Visualizer

Open [`output/knowledge_graph.html`](./output/knowledge_graph.html) in any web browser:
- **Click & Drag**: Nodes are physics-simulated and fully interactive.
- **Color Coding**:
  - 🔵 **Blue**: Persons (`Dr. Elena Vance`, `Julian Mercer`, `Dr. Kenji Sato`)
  - 🟢 **Green**: Organizations (`Helios Capital`, `Aurora Technologies`, `Synapse Dynamics`)
  - 🟣 **Purple**: Projects (`Project Nexus`)
  - 🟠 **Orange**: Technologies (`CryoQubit`, `Synapse-OS`)
- **Hover**: Displays node connectivity and edge relations (`INVESTED_IN`, `CO_FOUNDED`, etc.).

---

## 📝 Student Exercises & Lab Assignments

### Exercise 1: Graph Expansion
Create a new file `data/senate_hearing.txt`:
```text
Senator Robert Hayes opened a congressional inquiry into Julian Mercer's role
in funding Project Nexus. The Department of Defense confirmed interest in the technology.
```
Run `python3 graphrag_demo.py` and observe how the knowledge graph incorporates new nodes and relationships.

### Exercise 2: Compare Vector vs. Graph
Run `query_cli.py` with:
- A direct factual question: *"Where is Synapse Dynamics located?"* (Observe how both Vector and Graph succeed).
- A relational question: *"Who connects Dr. Elena Vance to Julian Mercer?"* (Observe why Graph is required).

### Exercise 3: Custom Entity Schema
In [`graphrag_demo.py`](./graphrag_demo.py), configure `SchemaLLMPathExtractor` to restrict extracted entities to specific types: `['RESEARCHER', 'INVESTOR', 'CORPORATION']`. Compare how strict schemas influence graph cleanliness.
