"""
# Last amended: 21st May, 2026
# My folder: D:\OneDrive\Documents\crewai\python_based
# Using langchain toos: DuckDuckGoSearchRun    

"""


# 1.0
from crewai.tools import BaseTool
from pydantic import Field
from crewai import Agent, Task, Crew, Process, LLM
# uv pip install -U ddgs
from langchain_community.tools import DuckDuckGoSearchRun


# 2.0 Define your Ollama model
ollama_llm = LLM(
                model="ollama/llama3.2:latest",        # Prefix with 'ollama/' followed by your model name
                base_url="http://localhost:11434" # Default Ollama local server URL
                )

# 3.0 Wrap langchain class in crewai class
class SearchTool(BaseTool):
    name: str = "DuckDuckGo Search"
    description: str = "Search the web with DuckDuckGo."
    search: DuckDuckGoSearchRun = Field(default_factory=DuckDuckGoSearchRun)

    def _run(self, query: str) -> str:
        return self.search.run(query)



# 4.0 Define your agent and attach the LangChain tools
researcher = Agent(
                    role='Senior Research Analyst',
                    goal='Uncover groundbreaking technologies and companies',
                    backstory='You are a master at digging up facts and details from the web and encyclopedias.',
                    tools=[SearchTool()],
                    llm = ollama_llm,
                    verbose=True
                    )

# Define the task
task1 = Task(
            description='Research Quantum Computing using Wikipedia, and gather the latest news using DuckDuckGo.',
            expected_output='A 3-paragraph summary of the latest trends in Quantum Computing.',
            agent=researcher
)

# Run the Crew
crew = Crew(
            agents=[researcher],
            tasks=[task1],
            process=Process.sequential
            )

result = crew.kickoff()
print(result)

#########################

