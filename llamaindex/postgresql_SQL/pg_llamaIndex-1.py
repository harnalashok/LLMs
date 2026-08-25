# Last amended: 25th August, 2026
# A simple way to connect postgresql database with llamaIndex


%reset -f


# 0. Call libraries

from llama_index.llms.ollama import Ollama
from llama_index.embeddings.ollama import OllamaEmbedding
# Settings is a global variable instantiated before it is imported
from llama_index.core import Settings


# 0.1 SQLDatabase class a lightweight container wrapper 
#      around a SQL database connection
from sqlalchemy import create_engine
from llama_index.core import SQLDatabase
from llama_index.core.query_engine import NLSQLTableQueryEngine


# 0.2
Settings.llm=None
Settings.embed_model=None



# 1. Configure the LLM (for SQL generation)
llm = Ollama(model="mistral:latest", 
            base_url="http://localhost:11434",
             request_timeout=240.0)

# 2. Configure the Embedding Model (for schema/metadata mapping)
# Ensure you have run 'ollama pull mxbai-embed-large' (or your preferred model)
embed_model = OllamaEmbedding(
                                model_name= "nomic-enbed-text" ,# "bge-m3",     # MAy have NaN problem. Use nomic-embed-text
                                base_url="http://localhost:11434",
                            )

# 3. Set global settings so LlamaIndex uses these local models
Settings.llm = llm
Settings.embed_model = embed_model


# 4. Connect to PostgreSQL
# Format: postgresql+psycopg2://user:password@host:port/dbname
# 4.1 Establish a standard SQLAlchemy connection engine
engine = create_engine("postgresql+psycopg2://ravi:ravi@localhost:5432/ravi")
# 4.2 Wrap it with SQLDatabase (you can limit it to specific tables)
sql_database = SQLDatabase(engine, include_tables=["s","p", "spj"] )

# 4.2.1 Only these tables are seen by the LLM
#target_tables = ["s","p", "spj"] 


# 4.3  Hand 'sql_database' to a Query Engine to let users chat with the data
#      We will use Ollama for both embedding the schema and generating the SQL
query_engine = NLSQLTableQueryEngine(
                                    sql_database=sql_database,
                                    llm=llm,
                                    #tables=target_tables,  # Limits context to only these tables
                                    )

# 5. Execute a query
#response = query_engine.query("List all tables and the count of rows in the users table and show me all data in table spj.")
response = query_engine.query("Show me all data in table spj.")

# 5.1
print(f"Response: {response}")

# 5.2
print(f"SQL Used: {response.metadata['sql_query']}")

################################3

