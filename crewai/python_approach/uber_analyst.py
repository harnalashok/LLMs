# https://medium.com/the-ai-forum/build-a-financial-analyst-agent-using-crewai-and-llamaindex-6553a035c9b8

# 1.0 Call libraries
from llama_index.llms.ollama import Ollama
from llama_index.embeddings.ollama import OllamaEmbedding
from llama_index.core import Settings
from llama_index.core import SimpleDirectoryReader, VectorStoreIndex
from llama_index.llms.openai import OpenAI
import os
from langchain_openai import ChatOpenAI

llm = Ollama(model="granite4.1:8b",
             request_timeout=800.0,
             temperature = 0.9
            )

Settings.llm = llm

# 4.2 Global Embedding Model
Settings.embed_model=embed_model = OllamaEmbedding(model_name="qwen3-embedding:0.6b")


reader = SimpleDirectoryReader(input_files=["uber_10k.pdf"])
docs = reader.load_data()
print(docs[1])
from llama_index.embeddings.huggingface import HuggingFaceEmbedding

index = VectorStoreIndex.from_documents(docs,
                                        embed_model=embed_model,
                                        )

query_engine = index.as_query_engine(similarity_top_k=5, llm=llm)

from crewai_tools import LlamaIndexTool
query_tool = LlamaIndexTool.from_query_engine(
    query_engine,
    name="Uber 2019 10K Query Tool",
    description="Use this tool to lookup the 2019 Uber 10K Annual Report",
)
#
#query_tool.args_schema.schema()

import os
from crewai import Agent, Task, Crew, Process,LLM
local_llm = LLM(
    model="ollama/granite4.1:8b",        # Prefix with 'ollama/' followed by your model name
    base_url="http://localhost:11434" # Default Ollama local server URL
)


# Define your agents with roles and goals
researcher = Agent(
    role="Senior Financial Analyst",
    goal="Uncover insights about different tech companies",
    backstory="""You work at an asset management firm.
  Your goal is to understand tech stocks like Uber.""",
    verbose=True,
    allow_delegation=False,
    tools=[query_tool],
    llm=local_llm,
    )
writer = Agent(
    role="Tech Content Strategist",
    goal="Craft compelling content on tech advancements",
    backstory="""You are a renowned Content Strategist, known for your insightful and engaging articles.
  You transform complex concepts into compelling narratives.""",
    llm=local_llm,
    verbose=True,
    allow_delegation=False,
)

# Create tasks for your agents
task1 = Task(
    description="""Conduct a comprehensive analysis of Uber's risk factors in 2019.""",
    expected_output="Full analysis report in bullet points",
    agent=researcher,
)

task2 = Task(
    description="""Using the insights provided, develop an engaging blog
  post that highlights the headwinds that Uber faces.
  Your post should be informative yet accessible, catering to a casual audience.
  Make it sound cool, avoid complex words.""",
    expected_output="Full blog post of at least 4 paragraphs",
    agent=writer,
)

crew = Crew(
    agents=[researcher, writer],
    tasks=[task1, task2],
    verbose =  True,  # You can set it to 1 or 2 to different logging levels
)

# Get your crew to work!
result = crew.kickoff()

print("######################")
print(result)

