"""
# Last amended: 19th Sep, 2026
Template for python programs
My folder: D:\Documents\OneDrive\Documents\crewai\python_based\CR1
GitHub: 
"""

##### Section 1: Libraries needed ###############

import os
from crewai import Agent, Crew, Process, Task, LLM



####### Section 2: API KEYS ####################

# 2. Set API keys here

#    os.environ["SERPER_API_KEY"] = "your-actual-api-key-here"
#    os.environ["GROQ_API_KEY"] =   "Your GrosAPIKEY-here"

######## Section 3 #################33


# 3. Define your local Ollama LLM configuration

local_llm = LLM(
                    model="ollama/qwen2.5:1.5b",        # Prefix with 'ollama/' followed by your model name
                    base_url="http://localhost:11434", # Default Ollama local server URL
                    timeout = 3000
                    # temperature=0.7,
                    # top_p=0.9
                )

# 3.1 Embedding model:

embed_model = {"provider": "ollama", "config": {"model_name": "granite-embedding"}} 


######## Section 4 Tools #################33
# Take help of AI in crewai docs
# Tool samples

"""
# 1.0
from crewai_tools import SerperDevTool
search_tool = SerperDevTool()
"""


"""
# 2.0
from crewai_tools import FileReadTool
file_read_tool = FileReadTool()            # agent supplies path at runtime
# or with a default file:
file_read_tool = FileReadTool(file_path='path/to/your/file.txt')
"""

"""
# 3.0
from crewai_tools import DirectoryReadTool
dir_read_tool = DirectoryReadTool()   # agent picks directory at runtime
# or fixed to one directory:
dir_read_tool = DirectoryReadTool(directory='/path/to/your/directory')
"""


######## Section 5 AGENTS #################33

Agent1 =      Agent(
                    role= "quick-brown-fox",
                    goal= "Find comprehensive market data on emerging technologies",
                    backstory="""
                               You are .........multi-line text
                               line2
                               line3
                               ..... 
                              """ , 
                    # 3. Assign the tool to the researcher agent so they can browse the web
                    tools=  [search_tool, file_read_tool, dir_read_tool, tool1, tool2,....],
                    llm= local_llm,
                    verbose=True
                  )


Agent2 =      Agent(
                    role= "quick-brown-fox",
                    goal= "Find comprehensive market data on emerging technologies",
                    backstory="""
                               You are .........multi-line text
                               line2
                               line3
                               ..... 
                              """ , 
                    # 3. Assign the tool to the researcher agent so they can browse the web
                    tools=  [search_tool, file_read_tool, dir_read_tool, tool1, tool2,....],
                    llm= local_llm,
                    verbose=True
                  )


Agent3 =      Agent(
                    role= "quick-brown-fox",
                    goal= "Find comprehensive market data on emerging technologies",
                    backstory="""
                               You are .........multi-line text
                               line2
                               line3
                               ..... 
                              """ , 
                    # 3. Assign the tool to the researcher agent so they can browse the web
                    tools=  [search_tool, file_read_tool, dir_read_tool, tool1, tool2,....],
                    llm= local_llm,
                    verbose=True
                  )



######## Section 5 TASKS #################33


Task1 =                 Task( description=  """
                                    CRITICAL REQUIREMENT: You MUST execute your 'Google Serper Search' tool to look up current market data. 
                                    Do NOT rely on your internal training knowledge or generate assumptions. 
                                    Your final response must be based strictly on fresh external research fetched during this run.
                                    Specifically search for current 2026 data regarding the market landscape for AI-powered healthcare solutions, 
                                    including key players, market size, and growth trends. Here is {path_to_file1}
                                    """ ,
                                expected_output= """
                                                    Give output as follows:
                                                    ---Bullet point 1
                                                    ---Bullet point 2
                                                """ ,
                                 markdown= True,               
                                 output_file="./data/somefile.md" ,         # if required
                                 agent=Agent1,
                            )




Task2 =                 Task(
                                description= """
                                    CRITICAL REQUIREMENT: You MUST execute your 'Google Serper Search' tool to look up current market data. 
                                    Do NOT rely on your internal training knowledge or generate assumptions. 
                                    Your final response must be based strictly on fresh external research fetched during this run.
                                    Specifically search for current 2026 data regarding the market landscape for AI-powered healthcare solutions, 
                                    including key players, market size, and growth trends. Here is {product_name}
                                    """,
                                expected_output= """
                                                    Give output as follows:
                                                    ---Bullet point 1
                                                    ---Bullet point 2
                                                """, 
                                 markdown= True,               
                                 output_file="./data/somefile.md" ,     # If required
                                 context= [ if_any1, if_any2]   ,
                                 agent = Agent2            
                            )


Task3 =                 Task(
                                description=  """
                                    CRITICAL REQUIREMENT: You MUST execute your 'Google Serper Search' tool to look up current market data. 
                                    Do NOT rely on your internal training knowledge or generate assumptions. 
                                    Your final response must be based strictly on fresh external research fetched during this run.
                                    Specifically search for current 2026 data regarding the market landscape for AI-powered healthcare solutions, 
                                    including key players, market size, and growth trends. Here is {topic_name}
                                    """,
                                expected_output= """
                                                    Give output as follows:
                                                    ---Bullet point 1
                                                    ---Bullet point 2
                                                """ ,
                                 markdown= True,               
                                 output_file=  "./data/somefile.md",              # If required
                                 context= [ if_any1, if_any2] ,               
                                 agent = Agent3
                            )


######## Section 6 Your Crew #################33



# Create the crew
crew_name = Crew(
                    agents=   [ Agent1, Agent2, Agent3 ],
                    tasks=    [Task1, Task2, Task3 ],
                    process=  Process.sequential,
                    memory =  True,
                    embedder= embed_model,
                    verbose=  True
                )



######## Section 7 Run Your Crew #################33


result = Crew.kickoff(inputs= {
                                "path_to_file": "/some/path/to/file.txt",
                                "product_name" : "SomeNAme",
                                "topic_name" :   "SomeTopic"
                               }
                    )

"""
OR
path = input("Enter path to file: ")
result = Crew.kickoff(inputs={"path_to_file": path})

"""