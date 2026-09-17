# https://medium.com/the-ai-forum/build-a-financial-analyst-agent-using-crewai-and-llamaindex-6553a035c9b8

# 1.0 Call libraries
from llama_index.llms.ollama import Ollama
from llama_index.embeddings.ollama import OllamaEmbedding
from llama_index.core import Settings
from llama_index.core import SimpleDirectoryReader, VectorStoreIndex

# 2.0
llm = Ollama(model="granite4.1:8b",
             request_timeout=800.0,
             temperature = 0.9
            )

# 2.1 Global Embedding Model
embed_model = OllamaEmbedding(model_name="qwen3-embedding:0.6b")

# 2.2
Settings.llm = llm
Settings.embed_model = embed_model

# Our data file
pdf = "/home/ashok/crewai_pjt/Exercises/data/sports.pdf"


reader = SimpleDirectoryReader(input_files=[pdf])
docs = reader.load_data()
print(docs[1])


#from llama_index.embeddings.huggingface import HuggingFaceEmbedding

index = VectorStoreIndex.from_documents(docs,
                                        embed_model=embed_model,
                                        )

query_engine = index.as_query_engine(similarity_top_k=5, llm=llm)



from crewai_tools import LlamaIndexTool

rag_tool = LlamaIndexTool.from_query_engine(
                                            query_engine,
                                            name="Sports_tool",
                                            description="Use this tool to lookup answers related to sports questions",
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
    role="Senior Sports Analyst",
    goal="To uncover insights about sports from the provided tool.",
    backstory="""You work at a sports firm. """,
    verbose=True,
    allow_delegation=False,
    tools=[rag_tool],
    llm=local_llm,
    )


# Create tasks for your agents
task1 = Task(
    description="""Answer faithfully any {questions} asked.""",
    expected_output="Do not answer from your own knowledge base but provided tool-output only.",
    agent=researcher,
)


crew = Crew(
    agents=[researcher],
    tasks=[task1],
    verbose =  True,  # You can set it to 1 or 2 to different logging levels
)

# Get your crew to work!
result = crew.kickoff( inputs={"questions": "Define  Physical Activity, Exercise and Training"})

print("######################")
print(result)

