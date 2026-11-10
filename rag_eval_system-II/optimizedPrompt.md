NOTES: i)  This optimized prompt was suggested by Gemini Flash3.8 considering the delay in creating
           the plan and implementation from 'prompt-II deepeval.txt'.       
       ii) Study suggestions here to create better prompts.      

<pre>
<overallPlan>
You are an expert Python AI engineer. Build and integrate two sub-systems:
1. A Retrieval-Augmented Generation (RAG) sub-system using LlamaIndex.
2. A fast, automated RAG performance evaluation sub-system using DeepEval.
3. Keep all system constants, such as, IP address, Ollama models used, chunk-size, ollama parameters, database name, its username and password, file/folder names etc as variables in a config file for ease of change or system up-gradation.
Work in the existing virtual environment at `/home/ashok/langchain` (`source /home/ashok/langchain/bin/activate`).
</overallPlan>

<RAGsubSystem>
Design an optimized, strictly grounded RAG sub-system:
1. LLM & Embeddings: 
   - LLM: `llama3.2:latest` via Docker Ollama at `http://192.240.1.27:11434` (temperature=0.0).
   - Embedding: `nomic-embed-text` (768 dimensions) via Ollama.
2. Vector Store: 
   - PostgreSQL database `gautam` (user: `gautam`, password: `gautam`) with `pgvector` extension.
3. Ingestion & Chunking Optimization:
   - Read markdown files from `dataFolder/`.
   - Chunk using `SentenceSplitter(chunk_size=512, chunk_overlap=50)`.
   - Set retrieval to `similarity_top_k=2` with Cosine similarity to keep context compact and evaluations fast.
4. Grounding & Refusal:
   - Answer queries SOLELY based on the retrieved vector store context. Never hallucinate or use pre-trained knowledge.
   - If context is insufficient, return exactly: "I do not have sufficient information in the provided context to answer this question."
5. Output:
   - Return both the extracted context chunks and the generated answer.
</RAGsubSystem>

<RAGEvalsubSystem>
Design a high-throughput DeepEval performance evaluation sub-system:
1. Framework: DeepEval (`deepeval`).
2. Fast Judge LLM:
   - Use `qwen2.5:latest` via Ollama at `http://192.240.1.27:11434`. (Do NOT use reasoning models like deepseek-r1 which generate excessive thinking tokens).
   - Configure Ollama with `generation_kwargs={"num_ctx": 8192}` and `temperature=0.0`.
3. Metrics:
   - Evaluate: `ContextualPrecisionMetric`, `ContextualRecallMetric`, `ContextualRelevancyMetric`, `AnswerRelevancyMetric`, and `FaithfulnessMetric`.
   - Set `async_mode=False` to prevent Ollama thread/queue contention.
4. Execution Flow:
   - Read `data.csv` (`text,question,idealAnswer`) row-by-row starting from row 1.
   - For each row, query RAG -> record context & response -> evaluate the 5 metrics with Judge LLM.
   - Immediately append the row results to:
     - Plain text log: `evaluation_results`
     - CSV table: `evaluation_results.csv`
     - Markdown report: `evaluation_results.md`
   - Include CLI options `--start-row`, `--max-rows`, and `--overwrite` to easily pause, resume, or test subset rows.
</RAGEvalsubSystem>
</pre>
