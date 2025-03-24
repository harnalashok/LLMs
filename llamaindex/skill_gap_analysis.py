
#----------- Libraries and modules -----------
# 1.0 SimpleDirectoryReader can also load metadata from a dictionary
#     https://docs.llamaindex.ai/en/stable/module_guides/loading/simpledirectoryreader/
from llama_index.core.readers import SimpleDirectoryReader
from llama_index.readers.file import PagedCSVReader

# 1.1 The Settings is a bundle of commonly used resources used 
#     during the indexing and querying stage in a LlamaIndex workflow/application.
from llama_index.core import Settings


# 1.2 Ollama related
# https://docs.llamaindex.ai/en/stable/examples/embeddings/ollama_embedding/
from llama_index.embeddings.ollama import OllamaEmbedding


# 1.3 Vector store related
import chromadb
from llama_index.core import StorageContext
from llama_index.core import VectorStoreIndex
from llama_index.vector_stores.chroma import ChromaVectorStore

# 1.4 Misc
import os
import pandas as pd

#--------Model related--------------

# 2.0 Define embedding function

                              )

embed_model= OllamaEmbedding(
                                    model_name="nomic-embed-text",      # Using foundational model may be overkill
                                    base_url="http://localhost:11434",
                                    #dimensions=512,
                                    #ollama_additional_kwargs={"mirostat": 0},
                                  )

Settings.embed_model = embed_model

# 2.1 Set llm_settings
# pip install llama-index-llms-mistralai
from llama_index.llms.mistralai import MistralAI
llm = MistralAI(api_key="VIScv20xwi7bmBbxZ6SiNJzkh35ZOWvM")
Settings.llm = llm

#---------------Read Data -----------------

# 2.2 Get Data:
from llama_index.core import Document

# 2.3 csv file location
file_path = '/home/ashok/Documents/csvrag/data/data.csv'  # insert the path of the csv file

df = pd.read_csv(file_path)

# 2.4 Change column names in Data Frame:
# df.rename(columns={'Roll Number': 'Roll_Number', 'Full Name': 'fullName', 'Experience': 'Experience'}, inplace=True) # Change column names

# 2.5
columns_of_interest = ['Roll_Number', 'fullName' ,'Gender', 'Degree', 'Experience', 'Certificates' ]

# 2.6  Reduce df columns to needed columns
df = df[columns_of_interest]

#----------------- Create vector store---------

# 3.0 Convert rows of the CSV into Document objects
documents = [Document(text=row.to_string()) for _, row in df[columns_of_interest].iterrows()]


# 3.1 This creates persistent collection. A folder by name of chromadb
#     is created and below that a chroma.sqlite3 database exists:

databasePath = "/home/ashok/Documents/chroma_db"
chroma_client = chromadb.PersistentClient(path=databasePath)

# 3.2 Check if collection exists. If so delete it.

if 'datastore' in chroma_client.list_collections():
    chroma_client.delete_collection("datastore")
    chroma_collection = chroma_client.create_collection("datastore")  
else:
    # Create collection afresh
    chroma_collection = chroma_client.create_collection("datastore")   


# 3.3 Set up a blank ChromaVectorStore and load in data
vector_store = ChromaVectorStore(chroma_collection=chroma_collection)

# 3.4
storage_context = StorageContext.from_defaults(vector_store=vector_store)

#------------ Vectorize now 

# 4.0 Takes docs and storage context:
#     Repeating this operation, doubles the number of vectors/records in the collection

index = VectorStoreIndex.from_documents(
                                         documents,
                                         storage_context=storage_context,
                                         show_progress= False                 # Show progress bar
                                        )

#-----------------Tools -------------------

# 5.0  Tools

from llama_index.core.tools import QueryEngineTool

# 5.1 Query Engine
vector_query_engine = index.as_query_engine()

# 5.2 Query engine tool
desc = "Your job is to query the stored data from file data.csv but NOT to search the "
read_tool = QueryEngineTool.from_defaults(
                                             query_engine=vector_query_engine,
                                             description=( desc
                                                           
                                                         ),
                                            )
# 5.3 search jobs tool
from tavily import AsyncTavilyClient

async def search_jobs_on_web(query: str) -> str:
    """Given the degree and specialization, search for jobs on the web where he can apply as per his qualifications. You are not to search for any other information on the web."""
    client = AsyncTavilyClient(api_key="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")
    return str(await client.search(query))

# 5.4 Course recommender tool
async def course_recommender(query: str) -> str:
    """Given the job requirments, recommend courses from the web ."""
    client = AsyncTavilyClient(api_key="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")
    return str(await client.search(query))

# 5.5 Function tools from functions
from llama_index.core.tools import FunctionTool

search_web_tool         = FunctionTool.from_defaults(fn= search_jobs_on_web)
course_recommender_tool = FunctionTool.from_defaults(fn=course_recommender)

#-------------AgentRunner and AgentWorker------------

# 6.0
from llama_index.core.agent import FunctionCallingAgentWorker
from llama_index.core.agent import AgentRunner

# 6.1 Define workers
agent_worker = FunctionCallingAgentWorker.from_tools(
                                                      [read_tool, search_web_tool, course_recommender_tool], 
                                                      llm=llm, 
                                                      verbose= True,  # Try also False
                                                    )

# 6.2 Define supervisor
agent = AgentRunner(agent_worker)

#-------------Chatting with the agent------------

response = agent.chat(
                      "Give all details of 'Rahul Kumar' having age of 23 from the data in the database"
                      )

print(response)

response = agent.chat("Search the web to list some jobs for him")
print(response)


response = agent.chat("Recommend some courses for Rahul as he wants to be data analyst")
print(response)



