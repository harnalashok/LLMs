# 25th August, 2026

"""

Dynamic Table Retrieval (Best for large databases)
If your database has dozens or hundreds of tables, you shouldn't send them 
all to the LLM at once. Instead, use an ObjectIndex to store your table schemas.
The system will then use your Ollama embedding model to find the most relevant 
tables for each specific question before generating the SQL

"""

%reset -f


# 0.0
from llama_index.llms.ollama import Ollama
from llama_index.embeddings.ollama import OllamaEmbedding
from llama_index.core import Settings

from sqlalchemy import create_engine
from llama_index.core import SQLDatabase

#from llama_index.core.query_engine import NLSQLTableQueryEngine
from llama_index.core.objects import SQLTableNodeMapping, ObjectIndex, SQLTableSchema
from llama_index.core.indices.struct_store import SQLTableRetrieverQueryEngine
from llama_index.core import VectorStoreIndex


# 0.1
Settings.llm=None
Settings.embed_model=None


# 1. Configure the LLM (for SQL generation)
llm = Ollama(model=  "granite4.1:3b", #             "mistral:latest", 
            base_url="http://localhost:11434",
             request_timeout=240.0)


# 2. Configure the Embedding Model (for schema/metadata mapping)
# Ensure you have run 'ollama pull mxbai-embed-large' (or your preferred model)
embed_model = OllamaEmbedding(
                                model_name="nomic-embed-text",
                                base_url="http://localhost:11434",
                            )

# 3. Set global settings so LlamaIndex uses these local models
Settings.llm = llm
Settings.embed_model = embed_model


# 4. Connect to PostgreSQL
# Format: postgresql+psycopg2://user:password@host:port/dbname
engine = create_engine("postgresql+psycopg2://ravi:ravi@localhost:5432/ravi")
sql_database = SQLDatabase(engine)


# 5. Map your database tables to searchable "Nodes"
#    "nodes" are objects that represent chunks of 
#     information—in this case, each node corresponds to
#     a table schema from your SQL database. What’s special
#     is that LlamaIndex treats nodes as first-class, embeddable, 
#     and retrievable units, enabling semantic search and flexible 
#      retrieval strategies
table_node_mapping = SQLTableNodeMapping(sql_database)

# 6. Create schema objects for all tables (or a subset)
table_schema_objs = [
    SQLTableSchema(table_name=t) 
    for t in ["s", "p", "j", "spj"]
]

# 6.1 SQLTableSchema only stores the table name (and optional context),
#      NOT the actual schema details (like columns or types)
for schema in table_schema_objs:
    print(schema)

# 6.2 Get full schema details of a table:
sql_database.get_single_table_info('spj')

# 7. Create a searchable index of these tables using your Ollama embed_model
#    This command creates a list of SQLTableSchema objects, one for each table name
#     in ["s", "p", "j", "spj"]. Each SQLTableSchema represents the structure of a 
#      specific SQL table, which can then be used for indexing, retrieval, or 
#       context in LlamaIndex pipelines (table_node_mapping.py).
"""
Here are the details:
table_schema_objs: A list of objects (e.g., SQLTableSchema), each representing a table schema you want to index
                   and retrieve semantically.
table_node_mapping: An object that defines how to convert between your schema objects and Node objects 
                    for indexing and retrieval.
VectorStoreIndex: The index class to use for storing and searching the nodes 
                  (here, a vector-based semantic index).
"""      

obj_index = ObjectIndex.from_objects(
                                    table_schema_objs,
                                    table_node_mapping,
                                    VectorStoreIndex,
                                    )
                                   

# 8. Use the Retriever Query Engine
# This will automatically pick the top 'k' relevant tables for every query

"""
What is the difference between 'SQLTableRetrieverQueryEngine' 
 and 'NLSQLTableQueryEngine'?

NLSQLTableQueryEngine converts natural language queries to SQL and
executes them on specified tables, best when you know which tables 
to query in advance.
SQLTableRetrieverQueryEngine dynamically retrieves relevant table 
schemas at query time (using an index), making it suitable for databases
with many tables or when you don't know which tables are needed beforehand.

"""

query_engine = SQLTableRetrieverQueryEngine(
                                            sql_database,
                                            obj_index.as_retriever(similarity_top_k=2), # Limits to 2 most relevant tables
                                            )

# 8.1
response = query_engine.query("What is the total number of rows in spj table?")

# 8.2
print(f"Response: {response}")
print(f"SQL Used: {response.metadata['sql_query']}")


##################
"""
NLSQLTableQueryEngine:
====================
Suppose you have tables s, p, j, and spj. If you know your queries will 
always involve these tables, you can use NLSQLTableQueryEngine and specify 
them up front:

python code
===========

query_engine = NLSQLTableQueryEngine(
    sql_database=sql_database,
    tables=["s", "p", "j", "spj"],
    llm=llm
)
response = query_engine.query("List all suppliers from table s")

Here, the engine always includes ALL the schemas for s, p, j, and spj in the prompt,
so it's efficient for a small, known set of tables.

SQLTableRetrieverQueryEngine:
=======================
If your database has many tables (including s, p, j, spj), and you want the engine 
to dynamically select (ONLY) the most relevant tables for each query, use SQLTableRetrieverQueryEngine:

python code
=========

# Build an index over all table schemas
table_node_mapping = SQLTableNodeMapping(sql_database)
table_schema_objs = [SQLTableSchema(table_name=t) for t in ["s", "p", "j", "spj"]]
obj_index = ObjectIndex.from_objects(table_schema_objs, table_node_mapping, VectorStoreIndex)
query_engine = SQLTableRetrieverQueryEngine(
    sql_database,
    obj_index.as_retriever(similarity_top_k=1)
)
response = query_engine.query("List all suppliers from table s")

Here, the engine retrieves only the most relevant table schemas 
(e.g., just s for this query) at query time, making it scalable for large 
or dynamic databases.

Summary:

    Use NLSQLTableQueryEngine for a fixed, small set of tables.
    Use SQLTableRetrieverQueryEngine for dynamic, large, or unknown sets of tables—retrieving only what’s needed per query.

"""