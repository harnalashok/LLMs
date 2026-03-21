"""

Dynamic Table Retrieval (Best for large databases)
If your database has dozens or hundreds of tables, you shouldn't send them 
all to the LLM at once. Instead, use an ObjectIndex to store your table schemas.
The system will then use your Ollama embedding model to find the most relevant 
tables for each specific question before generating the SQL

"""

from llama_index.core import SQLDatabase, Settings
from llama_index.llms.ollama import Ollama
from llama_index.embeddings.ollama import OllamaEmbedding
from llama_index.core.query_engine import NLSQLTableQueryEngine
from llama_index.core.objects import SQLTableNodeMapping, ObjectIndex, SQLTableSchema
from llama_index.core.indices.struct_store import SQLTableRetrieverQueryEngine
from llama_index.core import VectorStoreIndex
from sqlalchemy import create_engine


# 1. Configure the LLM (for SQL generation)
llm = Ollama(model="mistral:latest", 
            base_url="http://192.240.1.27:11434",
             request_timeout=240.0)

# 2. Configure the Embedding Model (for schema/metadata mapping)
# Ensure you have run 'ollama pull mxbai-embed-large' (or your preferred model)
embed_model = OllamaEmbedding(
                                model_name="nomic-embed-text",
                                base_url="http://192.240.1.27:11434",
                            )

# 3. Set global settings so LlamaIndex uses these local models
Settings.llm = llm
Settings.embed_model = embed_model

# 4. Connect to PostgreSQL
# Format: postgresql+psycopg2://user:password@host:port/dbname
engine = create_engine("postgresql+psycopg2://ravi:ravi@localhost:5432/ravi")
sql_database = SQLDatabase(engine)


# 1. Map your database tables to searchable "Nodes"
table_node_mapping = SQLTableNodeMapping(sql_database)

# 2. Create schema objects for all tables (or a subset)
table_schema_objs = [
    SQLTableSchema(table_name=t) 
    for t in ["s", "p", "j", "spj"]
]

# 3. Create a searchable index of these tables using your Ollama embed_model
obj_index = ObjectIndex.from_objects(
    table_schema_objs,
    table_node_mapping,
    VectorStoreIndex,
)

# 4. Use the Retriever Query Engine
# This will automatically pick the top 'k' relevant tables for every query
query_engine = SQLTableRetrieverQueryEngine(
                                            sql_database,
                                            obj_index.as_retriever(similarity_top_k=2), # Limits to 2 most relevant tables
                                            )

response = query_engine.query("What is the total number of rows in spj table?")


print(f"Response: {response}")
print(f"SQL Used: {response.metadata['sql_query']}")


