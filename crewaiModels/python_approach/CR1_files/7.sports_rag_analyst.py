# https://medium.com/the-ai-forum/build-a-financial-analyst-agent-using-crewai-and-llamaindex-6553a035c9b8

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


# 7.1 Create tasks for your agents
task1 = Task(
            description="""Answer faithfully any {questions} asked related to sports.""",
            expected_output="Do not answer from your own knowledge base but provided tool-output only.",
            agent=researcher,
            )           

# 8.0 Crew of agents
crew = Crew(
            agents=[researcher],
            tasks=[task1],
            verbose =  True,  # You can set it to 1 or 2 to different logging levels
            )


# 8.1 Get your crew to work!
result = crew.kickoff( inputs={"questions": "Define  Physical Activity, Exercise and Training"})

print("######################")
print(result)

