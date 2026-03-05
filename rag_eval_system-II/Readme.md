<pre>
# Last amended: 5th March, 2026
# Integrated RAG system with RAG System Evaluator
# Evaluates using: CorrectnessEvaluator, FaithfulnessEvaluator, RelevancyEvaluator, SemanticSimilarityEvaluator, PairwiseEvaluator
# Antigravity AI used: Claude Sonnet 4.6 (Thinking)
# Open markdown (.md) files with 'marktext'. Install, as: sudo snap install marktext



# 1. My prompt file:

prompt-II.txt
Antigravity AI used: Claude Sonnet 4.6 (Thinking)


# 2. Testing software installation:

	#  2.1 Check software versions
	source /home/ashok/langchain/bin/activate && pip list 2>&1 | grep -iE "llama|langchain|pgvector|psycopg|sqlalchemy|ollama"

	#  2.2 Check postgresql connectivity
	source /home/ashok/langchain/bin/activate
	cd /home/ashok/Documents/data/rag_system
	python -c "import psycopg2; conn = psycopg2.connect(dbname='gautam', user='gautam', password='gautam', host='localhost'); print('PG OK')"

	#  2.3 Check Ollama readability
	curl http://192.240.1.27:11434/api/tags


# 3. How are generated files placed:

/home/ashok/Documents/data/rag_system/
├── config.py            # Ollama/PostgreSQL/path constants
├── rag_system.py        # Sub-system 1: ingest + query
├── evaluation.py        # Sub-system 2: evaluation loop  
├── main.py              # CLI entry point
├── dataFolder/
│   ├── artificial_intelligence.md
│   ├── large_language_models.md
│   └── vector_databases.md
├── data.csv             # 9 QA pairs for evaluation
└── evaluation_results.csv  ← created after --evaluate run




# 3. How to run the system
#    Place all the files in ANY folder, not necessarily in ~/Documents/data/rag_system.
#    And then begin executing python commands as below.    

source /home/ashok/langchain/bin/activate
cd yourFolder


python main.py --ingest          # (already done — skip unless you add new .md files)
python main.py --query "your question here"
python main.py --evaluate        # runs all 9 QA pairs through Judge LLM → evaluation_results.csv

################
</pre>
