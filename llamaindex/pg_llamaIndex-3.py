"""
Give postgres table and column information for better understanding of the database

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
llm = Ollama(model="qwen3.5:cloud", 
	        base_url="http://192.240.1.27:11434",
            request_timeout=240.0
           )

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



# 5. Define table and specific column descriptions for your tables
#    The dictionary keys must match your actual table names in PostgreSQL
custom_metadata = {
    "s": {
        "table_description" :   "It contains Supplier details. His identifying number (snum), his name (sname), his status (status) and his city (city) of residence.",
        "column_descriptions": {
           			 "snum"  : "An identifying number for the supplier. It is also the primary key",
           			 "sname" : "Name of supplier.",
            			 "status": "status of supplier",
            			 "city"  : "The city of residence or office of supplier"
        			}
        },
    "p": {
         "table_description"  :  "It contains Parts details. Identifying part number (pnum), part-name (pname), part-color (color), part-weight (weight) and part-city (city) of supply",
        "column_descriptions": {
            			"pnum": "Part number. It is also the primary key.",
            			"pname": "Unique alphanumeric code used to join with the shipping table.",``
            			"color" : "Color of the part",
            			"weight" : "weight of the part" ,
            			"city" : "city where part is manufactured"
        			}
    	},
    "j": {
        "table_description"  : "It contains details about Projects. Identifying project number (jnum), project name (jname) and project city (city) ",
        "column_descriptions": {
            			"jnum": "Project number. A unique number. It identifies the project.",
            			"jname" : "Name of the project",
            			"city" : "City where project is located"
        			}
    	},
    "spj": {
        "table_description" :  "This table links suppliers table, s, and parts table, p, with projects table, j. It tells which supplier is supplying which part to which project in what quantity.",
        "column_descriptions": {
            			"snum": "Identifying number for the supplier",
            			"pnum": "Identifying number for the part",
            			"jnum" : "Identifying number for the project",
            			"qty" : "Quantity of the part supplied to the project by the supplier"
        			}
    	},	
    	
}

# 5.1 Create SQLDatabase with custom metadata
sql_database = SQLDatabase(
                            engine, 
                            custom_table_info = custom_metadata
                          )


# 6. Initialize the Query Engine
# It will now use Ollama for both embedding the schema and generating the SQL
query_engine = NLSQLTableQueryEngine(
                                    sql_database=sql_database,
                                    llm=llm
                                    )

# 7. Execute a query
#response = query_engine.query("Give details of part numbers supplied to project J1 by supplier whose name is Smith")
response = query_engine.query("Give details of those part numbers (pnum) that are supplied to project number J1 by supplier whose name is Smith")
print(response)

print(f"Response: {response}")
print(f"SQL Used: {response.metadata['sql_query']}")


