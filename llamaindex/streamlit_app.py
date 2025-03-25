import streamlit as st
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
    return str( client.search(query))

# 5.4 Course recommender tool
async def course_recommender(query: str) -> str:
    """Given the job requirments, recommend courses from the web ."""
    client = AsyncTavilyClient(api_key="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")
    return str( client.search(query))

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



#################$$$$$$$$$$$$$4



st.set_page_config(page_title="Chat with the Streamlit docs, powered by LlamaIndex", page_icon="🦙", layout="centered", initial_sidebar_state="auto", menu_items=None)

st.title("Chat with the Streamlit docs, powered by LlamaIndex 💬🦙")
st.info("Check out the full tutorial to build this app in our [blog post](https://blog.streamlit.io/build-a-chatbot-with-custom-data-sources-powered-by-llamaindex/)", icon="📃")

if "messages" not in st.session_state.keys():  # Initialize the chat messages history
    st.session_state.messages = [
        {
            "role": "assistant",
            "content": "Ask me a question about Streamlit's open-source Python library!",
        }
    ]


if "chat_engine" not in st.session_state.keys():  # Initialize the chat engine
    st.session_state.chat_engine = agent

if prompt := st.chat_input(
    "Ask a question"
):  # Prompt for user input and save to chat history
    st.session_state.messages.append({"role": "user", "content": prompt})

for message in st.session_state.messages:  # Write message history to UI
    with st.chat_message(message["role"]):
        st.write(message["content"])

# If last message is not from assistant, generate a new response
if st.session_state.messages[-1]["role"] != "assistant":
    with st.chat_message("assistant"):
        response_stream = st.session_state.chat_engine.chat(prompt)
        st.write(response_stream.response)
        message = {"role": "assistant", "content": response_stream.response}
        # Add response to message history
        st.session_state.messages.append(message)
