# A simple way to connect postgresql database with llamaIndex


from llama_index.core import SQLDatabase, Settings
from llama_index.llms.ollama import Ollama
from llama_index.embeddings.ollama import OllamaEmbedding
from llama_index.core.query_engine import NLSQLTableQueryEngine
from llama_index.core.objects import SQLTableNodeMapping, ObjectIndex, SQLTableSchema
from llama_index.core.indices.struct_store import SQLTableRetrieverQueryEngine
from sqlalchemy import create_engine

# 1. Configure the LLM (for SQL generation)
llm = Ollama(model="mistral:latest", 
            base_url="http://192.240.1.27:11434",
             request_timeout=240.0)

# 2. Configure the Embedding Model (for schema/metadata mapping)
# Ensure you have run 'ollama pull mxbai-embed-large' (or your preferred model)
embed_model = OllamaEmbedding(
                                model_name="bge-m3",     # MAy have NaN problem. Use nomic-embed-text
                                base_url="http://192.240.1.27:11434",
                            )

# 3. Set global settings so LlamaIndex uses these local models
Settings.llm = llm
Settings.embed_model = embed_model


# 4. Connect to PostgreSQL
# Format: postgresql+psycopg2://user:password@host:port/dbname
engine = create_engine("postgresql+psycopg2://ravi:ravi@localhost:5432/ravi")
sql_database = SQLDatabase(engine)

# 4.1 Only these tables are seen by the LLM
target_tables = ["s","p", "spj"] 


# 5. Initialize the Query Engine
# It will now use Ollama for both embedding the schema and generating the SQL
query_engine = NLSQLTableQueryEngine(
                                    sql_database=sql_database,
    tables=target_tables,  # Limits context to only these tables
    llm=llm
)

# 6. Execute a query
#response = query_engine.query("List all tables and the count of rows in the users table and show me all data in table spj.")
response = query_engine.query("Show me all data in table spj.")
print(f"Response: {response}")
print(f"SQL Used: {response.metadata['sql_query']}")

################################3

