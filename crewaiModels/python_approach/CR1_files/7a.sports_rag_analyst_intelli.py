# Last amended: 26th Sep, 2026
# Accessing llamaindex RAG through agents
# https://medium.com/the-ai-forum/build-a-financial-analyst-agent-using-crewai-and-llamaindex-6553a035c9b8

"""
=================
What is different?
==================

In this example instead of my asking the RAG a question,
as in the example: 7.sports_rag_analyst.py', the question
to RAG is framed and asked by Agent.
Para 7.1 onwards there is difference 

"""




# 1.0 Call libraries
from llama_index.llms.ollama import Ollama
from llama_index.embeddings.ollama import OllamaEmbedding
from llama_index.core import Settings
from llama_index.core import SimpleDirectoryReader, VectorStoreIndex

####### Model(s) to use ###########3 

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

########## Data ingestion ###############

# 3.0 Our data file
path_to_folder = "/home/ashok/crewai_pjt/Exercises/data"
path_to_file = "/home/ashok/crewai_pjt/Exercises/data/sports.pdf"

# 3.1
reader = SimpleDirectoryReader(input_files=[path_to_file ])
docs = reader.load_data()
print(docs[1])

# 4.0 dataindex is handle to vector index
dataindex = VectorStoreIndex.from_documents(docs,
                                            embed_model=embed_model,
                                            )

# 4.1 Attach a query engine to dataindex
sports_query_engine = dataindex.as_query_engine(
                                                similarity_top_k=5,
                                                llm=llm
                                                )

####### Agents desigining ###########3 

# 5.0 Tools 

# 5.1
from crewai import Agent, Task, Crew, Process,LLM
from crewai_tools import LlamaIndexTool

# 5.2
sports_rag_tool = LlamaIndexTool.from_query_engine(
                                                    sports_query_engine,
                                                    name="Sports_tool",
                                                    description="""
                                                    Use this tool to lookup answers 
                                                    related to sports questions""",
                                                    )

# 6.0 Which LLM
local_llm = LLM(
                model="ollama/granite4.1:8b",        # Prefix with 'ollama/' followed by your model name
                base_url="http://localhost:11434" # Default Ollama local server URL
                )


# 7.0 Define your agents with roles and goals
researcher = Agent(
                    role="Senior Sports Analyst",
                    goal="To uncover insights about sports from the provided tool.",
                    backstory="""You have won medals at Aisan games. 
                                 You have been working at a decathlon since last 10 years. """,
                    verbose=True,
                    allow_delegation=False,
                    tools=[sports_rag_tool],
                    llm=local_llm,
                    )



"""
Why the change?
In example, '7a.sports_rag_analyst', we are handing the agent a pre-formed question 
({questions}) and telling it to answer it using the tool. To make the agent decide 
what to ask the RAG tool, give it a broader goal/topic instead of a literal question,
and let the agent's own reasoning formulate the query it sends to sports_rag_tool.
Here's the modified section (everything above # 7.1 stays the same):

"""
# 7.1 Create tasks for your agents — agent formulates its own question(s) to the tool
task1 = Task(
    description="""You are researching the topic: {topic}.
    Decide for yourself what specific question(s) you need to ask the 
    Sports_tool to gather the information needed to cover this topic well.
    Formulate the question(s) yourself, query the tool, and base your 
    answer strictly on what the tool returns — do not rely on your own 
    prior knowledge.""",
    expected_output="""A well-informed summary on the topic, built entirely 
    from information retrieved via the tool. Also state what question(s) 
    you asked the tool to arrive at this answer.""",
    agent=researcher,
)

# 8.0 Crew of agents
crew = Crew(
    agents=[researcher],
    tasks=[task1],
    verbose=True,
)

# 8.1 Get your crew to work! — pass a TOPIC, not a question
result = crew.kickoff(inputs={"topic": "Physical Activity, Exercise and Training"})

print("######################")
print(result)
