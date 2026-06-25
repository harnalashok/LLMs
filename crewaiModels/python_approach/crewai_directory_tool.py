"""
# Last amended: 9th June, 2026
# A tool to access directory
#   but without using MCP server
"""


# 0.0
from crewai import Agent, Task, Crew, LLM
from crewai_tools import DirectoryReadTool


# 1. Define your local Ollama LLM configuration
local_llm = LLM(
                model="ollama/qwen2.5:latest",     # Prefix with 'ollama/' followed by your model name
                base_url="http://localhost:11434"   # Default Ollama local server URL
                )



# 2. Initialize tool (fixed or dynamic directory)
tool = DirectoryReadTool(directory='/home/ashok/finance_pjt/')

# 3.0
agent = Agent(
                role='File Analyst',
                goal='List and analyze directory contents',
                backstory='An expert at navigating file systems.',
                tools=[tool],
                llm = local_llm,
            )

# 3.1
task = Task(
            description='List all files in the project directory.',
            expected_output='A complete list of files and subdirectories.',
            agent=agent,
            )

# 4.0
crew = Crew(agents=[agent], 
            tasks=[task],
            verbose = True,
            tracing=True,
            )

# 4.1
crew.kickoff()

##########################