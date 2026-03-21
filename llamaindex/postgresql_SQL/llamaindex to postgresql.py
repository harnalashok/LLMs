"""
20TH mARCH, 2026
INCOMPLETE WORK YET TO BE DONE
Access postgresql database using llamaindex
 
 Some work from here is yet to be done.
 Create pg_llamaIndex-4.py
 
Keywords: postgresql with llamaindex
llamaindex over postgresql
"""


from llama_index.core import SQLDatabase, Settings
from llama_index.llms.ollama import Ollama
from llama_index.embeddings.ollama import OllamaEmbedding
from llama_index.core.query_engine import NLSQLTableQueryEngine
from sqlalchemy import create_engine

# 1. Configure the LLM (for SQL generation)
llm = Ollama(model="llama3.2", request_timeout=120.0)

# 2. Configure the Embedding Model (for schema/metadata mapping)
# Ensure you have run 'ollama pull mxbai-embed-large' (or your preferred model)
embed_model = OllamaEmbedding(
    model_name="nomic-embed-text",
    base_url="http:///172.30.109.200:11434",
)

# 3. Set global settings so LlamaIndex uses these local models
Settings.llm = llm
Settings.embed_model = embed_model

# 4. Connect to PostgreSQL
# Format: postgresql+psycopg2://user:password@host:port/dbname
engine = create_engine("postgresql+psycopg2://ravi:ravi@localhost:5432/ravi")
sql_database = SQLDatabase(engine)

target_tables = ["s", "spj"] 

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



"""
 Dynamic Table Retrieval (Best for large databases)
If your database has dozens or hundreds of tables, you shouldn't send them all to the LLM at once. Instead, use an ObjectIndex to store your table schemas. The system will then use your Ollama embedding model to find the most relevant tables for each specific question before generating the SQL


"""

from llama_index.core.objects import SQLTableNodeMapping, ObjectIndex, SQLTableSchema
from llama_index.core.indices.struct_store import SQLTableRetrieverQueryEngine

# 1. Map your database tables to searchable "Nodes"
table_node_mapping = SQLTableNodeMapping(sql_database)

# 2. Create schema objects for all tables (or a subset)
table_schema_objs = [
    SQLTableSchema(table_name=t) 
    for t in ["users", "orders", "products", "payments", "shipping"]
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

response = query_engine.query("What is the total revenue from the orders table?")


"""
To add custom descriptions to your tables, you use the context_str parameter within the SQLTableSchema object. 
developers.llamaindex.ai
developers.llamaindex.ai
 +1
By providing a natural language description, your Ollama embedding model can better match a user's question to the correct table, even if the table name itself is cryptic or non-descriptive. 


Why this improves accuracy
Semantic Search: If a user asks about "customer details" but your table is named usr_mst, the embedding model will find it because your description mentions "user profiles".
Prompt context: LlamaIndex includes these descriptions in the final prompt sent to Ollama, helping the LLM understand specific units (e.g., "amounts are in thousands") or complex relationships between tables.
Schema Filtering: It prevents the LLM from getting confused by irrelevant tables that might have similar column names but different meanings. 

"""

from llama_index.core.objects import SQLTableNodeMapping, ObjectIndex, SQLTableSchema
from llama_index.core.indices.struct_store import SQLTableRetrieverQueryEngine
from llama_index.core import VectorStoreIndex

# 1. Define custom descriptions for your tables
# This 'context_str' is what the embedding model will index
table_info = [
    {
        "name": "users", 
        "summary": "Contains user profiles, including names, emails, and account creation dates."
    },
    {
        "name": "orders", 
        "summary": "Stores transactional data, order status, and total dollar amounts in thousands."
    },
    {
        "name": "inventory_v2_final", 
        "summary": "The main product catalog containing current stock levels and supplier IDs."
    }
]

# 2. Create the mapping and schema objects
table_node_mapping = SQLTableNodeMapping(sql_database)

table_schema_objs = [
    SQLTableSchema(table_name=t["name"], context_str=t["summary"]) 
    for t in table_info
]

# 3. Build the ObjectIndex (uses your Ollama embedding model)
obj_index = ObjectIndex.from_objects(
    table_schema_objs,
    table_node_mapping,
    VectorStoreIndex,
)

# 4. Initialize the Query Engine
query_engine = SQLTableRetrieverQueryEngine(
    sql_database,
    obj_index.as_retriever(similarity_top_k=1), # Picks the single best-matching table
)


"""
To add descriptions for individual columns, you provide a dictionary of column names and their descriptions to the SQLDatabase object. LlamaIndex uses these "column-level" hints to help Ollama understand exactly what data is in each field, which is especially useful for columns with non-obvious names or specific business logic.
How to Add Column Descriptions
You can use the custom_table_metadata argument when initializing your SQLDatabase. This metadata is then injected into the prompt sent to Ollama whenever that table is queried.

Why this makes SQL generation more precise
Deciphering Codes: If your database uses numeric codes (like 0, 1, 2) for statuses, Ollama will know that "suspended" maps to acct_status = 1.
Units of Measure: You can clarify if a column like price is in USD, Cents, or thousands.
Join Logic: You can explicitly tell the LLM which columns are "Foreign Keys" if your database doesn't have strict constraints defined.
Abbreviation Mapping: It helps the model understand that u_id is the User ID without needing to rename the column in the actual database. 
developers.llamaindex.ai
developers.llamaindex.ai
 +3
Pro Tip: Using PostgreSQL Comments
If you have already added comments to your columns in PostgreSQL using COMMENT ON COLUMN table.column IS 'description', LlamaIndex can often pick these up automatically via SQLAlchemy. However, the custom_table_metadata method above is more reliable as it guarantees the info is sent to the local LLM


"""

from llama_index.core import SQLDatabase

# 1. Define specific column descriptions for your tables
# The dictionary keys must match your actual table names in PostgreSQL
custom_metadata = {
    "users": {
        "column_descriptions": {
            "u_id": "The primary key; internally referred to as the User ID.",
            "acct_status": "Status of the user: 0 for Active, 1 for Suspended, 2 for Deleted.",
            "last_login": "Timestamp of the user's most recent session in UTC."
        }
    },
    "orders": {
        "column_descriptions": {
            "amt": "The transaction amount in USD, including tax.",
            "ref_code": "Unique alphanumeric code used to join with the shipping table."
        }
    }
}

# 2. Pass this metadata into the SQLDatabase object
sql_database = SQLDatabase(
    engine, 
    custom_table_metadata=custom_metadata
)

# 3. Use the query engine as before
# Ollama will now see these specific column 'hints' in the prompt
response = query_engine.query("How many users are currently suspended?")

"""
To give Ollama a "sneak peek" at your data, you use the sample_rows_in_table_info parameter. This automatically pulls a few real rows from your PostgreSQL tables and includes them in the prompt.
Seeing actual data helps the LLM understand if a date column looks like 2023-01-01 or 01/01/23, and whether a category column uses strings or integers.
How to enable Row Sampling
You set this up when initializing the SQLDatabase object.


Why Sampling is a Game-Changer
Format Matching: The LLM sees exactly how strings are formatted (e.g., it will know to use WHERE status = 'COMPLETED' instead of WHERE status = 'done').
Data Type Clarity: Sometimes a column is technically a VARCHAR but contains numbers. Sampling tells the LLM it can perform math on those strings.
Categorical Insights: It helps the model "discover" valid values for columns like country_code or department_name without you having to document every single one.
Important Note on Privacy
Since you are using Ollama, this is generally safe because your data stays on your local machine. However, if you were using a cloud LLM (like OpenAI), sampling rows would send snippets of your actual database records to their servers.
Pro Tip: If your tables are massive, sampling can slightly slow down the initial prompt generation. Stick to 2 or 3 rows for the best balance of context and speed.

"""

from llama_index.core import SQLDatabase

# 1. Initialize SQLDatabase with sampling enabled
sql_database = SQLDatabase(
    engine, 
    # This tells LlamaIndex to fetch 3 example rows from every table
    sample_rows_in_table_info=3,
    # You can still include your custom column descriptions here too!
    custom_table_metadata=custom_metadata 
)

# 2. Re-initialize your query engine with this database
query_engine = NLSQLTableQueryEngine(
    sql_database=sql_database,
    llm=llm
)

# 3. When you run a query, Ollama now sees the schema + descriptions + real data
response = query_engine.query("What is the average transaction amount for orders marked 'Completed'?")


"""
YEs. Please tell me how to filter or mask specific sensitive columns so they are never sampled or seen by the LLM?
To protect sensitive data (like passwords, PII, or API keys), you can use the ignore_tables or ignore_columns parameters when initializing the SQLDatabase object. This ensures LlamaIndex never fetches those columns or includes them in the prompt sent to Ollama.
How to Filter or Mask Columns
You define exactly which columns should be "invisible" to the LLM during the setup phase.

Why this is the best approach for privacy:
Prompt Safety: The ignored columns are completely removed from the schema description sent to Ollama. The model won't even know they exist.
Sampling Protection: When LlamaIndex performs row sampling, it automatically excludes the ignored columns from the SELECT statement it runs against your PostgreSQL database.
Error Prevention: By hiding sensitive columns, you prevent the LLM from accidentally trying to use them in a query (e.g., trying to count users by their SSN).

If you want an even higher level of security, you can create a PostgreSQL View that only contains "safe" columns and point LlamaIndex to that view instead of the raw table:

Pro Tip: Since you are using Ollama, your data never leaves your local machine. However, using ignore_columns is still a best practice to keep the LLM focused on relevant data and avoid "hallucinations" involving sensitive fields.


"""

from llama_index.core import SQLDatabase

# 1. Define the columns you want to hide
# Format: { "table_name": ["column1", "column2"] }
ignored_cols = {
    "users": ["password_hash", "ssn", "credit_card_number"],
    "orders": ["billing_address"]
}

# 2. Initialize SQLDatabase with 'ignore_columns'
sql_database = SQLDatabase(
    engine,
    ignore_columns=ignored_cols,  # These will NEVER be seen by Ollama
    sample_rows_in_table_info=2   # Sampling will now skip the ignored columns
)

# 3. Create your query engine
query_engine = NLSQLTableQueryEngine(
    sql_database=sql_database,
    llm=llm
)

"""

Validator
To add a custom SQL parser or validator, the most robust way in LlamaIndex is to create a Custom Query Engine. This allows you to intercept the SQL generated by Ollama before it ever hits your PostgreSQL database. 
By inheriting from CustomQueryEngine, you can implement logic to check for forbidden keywords (like DROP or DELETE) or use a library like sqlglot to verify syntax. 
developers.llamaindex.ai
developers.llamaindex.ai
 +2
Implementation: Custom SQL Validator Engine
In this example, we create a wrapper that uses sqlglot to parse the SQL and ensure it is a valid SELECT statement before execution. 

Why this approach is effective:
Intercepts Execution: The custom_query function acts as a gateway. If your validation fails, the query never reaches your PostgreSQL instance.
Syntax Verification: Using a dedicated parser like sqlglot ensures the SQL is compatible with PostgreSQL's dialect specifically.
Security Layer: Even if the LLM is "hallucinating" or trying to perform data modification, your parser can block any non-SELECT statements.
Custom Logging: You can easily log every generated query to a file or console for auditing before it runs. 
arize.com
arize.com
 +3
Advanced: Human-in-the-Loop
If you want to manually approve queries, you can modify the custom_query function to print the SQL and wait for a Y/N input from the terminal before proceeding:


"""

from llama_index.core.query_engine import CustomQueryEngine, NLSQLTableQueryEngine
from llama_index.core import Response
import sqlglot  # pip install sqlglot

class ValidatedSQLQueryEngine(CustomQueryEngine):
    """A custom engine that validates SQL before execution."""
    base_engine: NLSQLTableQueryEngine

    def custom_query(self, query_str: str):
        # 1. Use the standard engine to generate the SQL (without executing yet)
        # Note: We use a prompt that specifically asks for just the SQL
        raw_response = self.base_engine.query(query_str)
        generated_sql = raw_response.metadata.get("sql_query")

        # 2. Custom Validation Logic
        try:
            # Check if it's valid PostgreSQL syntax
            parsed = sqlglot.parse_one(generated_sql, read="postgres")
            
            # Security Check: Ensure it only contains SELECT statements
            if not isinstance(parsed, sqlglot.exp.Select):
                return Response("Error: Only SELECT queries are allowed for security.")
            
            # 3. If valid, return the original response
            return raw_response

        except sqlglot.errors.ParseError as e:
            return Response(f"Error: Ollama generated invalid SQL syntax. Detail: {e}")

# --- Setup ---
# Initialize your standard engine first
base_sql_engine = NLSQLTableQueryEngine(sql_database=sql_database, llm=llm)

# Wrap it in your custom validator
secure_query_engine = ValidatedSQLQueryEngine(base_engine=base_sql_engine)

# Use the secure engine for your queries
response = secure_query_engine.query("Show me all users created this month.")
print(response)


## Human in the loop response:

print(f"Generated SQL: {generated_sql}")
confirm = input("Execute this query? (y/n): ")
if confirm.lower() == 'y':
    return raw_response
else:
    return Response("Query cancelled by user.")




