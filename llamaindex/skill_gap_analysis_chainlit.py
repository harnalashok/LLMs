# Notes: 
#           a. The RAG library uses llama_index (para AA.)
#              (it requires a special python environment)
#           b. llm used here is MistralAI.  (pata BB)
#              (the API needs to be purchased)
#           c. The embedding model is of ollama. (para BB)
#           d. Vector store is chromadb (para CC)
#              (Vector store needs to be updated through cron job.
#           e. Rename and select columns of data in para CC.
#           f. For web search tavily is used. (para FF.)
#              (the API needs to be purchased)


#----------- AA. Libraries and modules -----------
# 1.0 SimpleDirectoryReader can also load metadata from a dictionary
#     https://docs.llamaindex.ai/en/stable/module_guides/loading/simpledirectoryreader/
import chainlit as cl   
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

from llama_index.core.agent import FunctionCallingAgentWorker
from llama_index.core.agent import AgentRunner

# 1.4 Misc
import os
import pandas as pd



#--------BB. Model related--------------

# 2.0 Define embedding function

                              

embed_model= OllamaEmbedding(
                                    model_name="nomic-embed-text",      # Using foundational model may be overkill
                                    base_url="http://localhost:11434",
                                    #dimensions=512,
                                    #ollama_additional_kwargs={"mirostat": 0},
                                  )

Settings.embed_model = embed_model

# 2.1 Set llm_settings:
#     MistralAI is used here.
#     The api_key is obtained from MistralAI
#     pip install llama-index-llms-mistralai
from llama_index.llms.mistralai import MistralAI
llm = MistralAI(api_key="VIScv20xwi7bmBbxZ6SiNJzkh35ZOWvM")
Settings.llm = llm


#------------------Read Index from disk-----------
# Load from disk

db2 = chromadb.PersistentClient(path="~/Documents/chroma_db")
chroma_collection = db2.get_or_create_collection("datastore")
vector_store = ChromaVectorStore(chroma_collection=chroma_collection)
index = VectorStoreIndex.from_vector_store(
                                           vector_store,
                                           embed_model=embed_model,
                                          )


#-----------------FF. Tools -------------------

# 5.0  Tools

from llama_index.core.tools import QueryEngineTool

# 5.1 Query Engine
vector_query_engine = index.as_query_engine()

# 5.2 Query engine tool
desc = "Your job is only to answer from the file data.csv. You will neither search the web nor answer from prior knowledge"
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


#-------------GG. AgentRunner and AgentWorker------------

# 6.0


# 6.1 Define workers
agent_worker = FunctionCallingAgentWorker.from_tools(
                                                      [read_tool, search_web_tool, course_recommender_tool], 
                                                      llm=llm, 
                                                      verbose= True,  # Try also False
                                                    )

# 6.2 Define supervisor
agent = AgentRunner(agent_worker)


# ---------------------- CHAINLIT CHAT INTERFACE ------------------------

# Called when chat session starts
@cl.on_chat_start
def start():
    # Save the query engine and CSV data to the session state
    cl.user_session.set("agent", agent)
    

    # Send welcome message to the user
    cl.Message(content="✅ CSV loaded and indexed! Ask me about job responsibilities for any job title and company.").send()

# Called whenever the user sends a message
@cl.on_message
def main(message: cl.Message):
    query = message.content                     # Get the user's question
    agent = cl.user_session.get("agent")

    # Use LLM to respond to the user's question based on indexed data
    response = agent.chat(query)
    cl.Message(content=response.response).send()  # Send the LLM's response

# --------------------------- RUN APP LOCALLY ---------------------------

# This ensures the app runs only when the script is executed directly
if __name__ == "__main__":
    cl.run()    # Launches the Chainlit app






#-------------HH. Chatting with the agent------------

response = agent.chat(
                      "Give all details of 'Rahul Kumar' having age of 23."
                      )

print(response)

response = agent.chat("Search the web to list some jobs for him")
print(response)


response = agent.chat("Recommend some courses for Rahul as he wants to be data analyst")
print(response)

