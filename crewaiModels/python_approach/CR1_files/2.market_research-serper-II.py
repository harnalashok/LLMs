"""
# LAst amended: 6th Sep, 2026
research_task modified.
But reply has hallucination
llama3.2 Model NOT good
Change the model to: granite4.1:8b
My folder: D:\Documents\OneDrive\Documents\crewai\python_based

"""

import os
from crewai import Agent, Crew, Process, Task, LLM
# 1. Import the Serper/SerpAPI search tool
from crewai_tools import SerperDevTool

# 2. Initialize the search tool (Requires SERPER_API_KEY in your environment variables)
#    export SERPER_API_KEY="your_api_key_here"
#    export SERPER_API_KEY="c374574bf69fc2eeaa6a021831fe29e52ec3cd7a" 
os.environ["OPENAI_API_KEY"] = "your-actual-api-key-here"
search_tool = SerperDevTool()

"""
Ref: https://docs.crewai.com/v1.15.18/en/tools/search-research/serperdevtool
The SerperDevTool comes with several parameters that will be passed to the API :

    1. search_url: The URL endpoint for the search API. (Default is https://google.serper.dev/search)
    2. country: Optional. Specify the country for the search results.
    3. location: Optional. Specify the location for the search results.
    4. locale: Optional. Specify the locale for the search results.
    5. n_results: Number of search results to return. Default is 10

Examples:

    tool = SerperDevTool(
        search_url="https://google.serper.dev/scholar",
        n_results=2,
        )

    tool = SerperDevTool(
        country="fr",
        locale="fr",
        location="Paris, Paris, Ile-de-France, France",
        n_results=2,
        )


"""

# 3. Define your local Ollama LLM configuration
# Change 'llama3' to any model you have downloaded locally (e.g., 'mistral', 'phi3', etc.)
# 2. Define your local Ollama LLM configuration
# Change 'llama3' to any model you have downloaded locally (e.g., 'mistral', 'phi3', etc.)
local_llm = LLM(
    model="ollama/qwen2.5:1.5b",        # Prefix with 'ollama/' followed by your model name
    base_url="http://localhost:11434" # Default Ollama local server URL
)

# Create specialized agents



researcher = Agent(
    role="Market Research Specialist",
    goal="Find comprehensive market data on emerging technologies",
    backstory="You are an expert at discovering market trends and gathering data.",
    # 3. Assign the tool to the researcher agent so they can browse the web
    tools=[search_tool],
    llm=local_llm,
    verbose=True
)

analyst = Agent(
    role="Market Analyst",
    goal="Analyze market data and identify key opportunities",
    backstory="You excel at interpreting market data and spotting valuable insights.",
    llm=local_llm,
    # The analyst focuses on synthesis, so they don't necessarily need the search tool
    verbose=True
)

research_task = Task(
    description=(
        "CRITICAL REQUIREMENT: You MUST execute your 'Google Serper Search' tool to look up current market data. "
        "Do NOT rely on your internal training knowledge or generate assumptions. "
        "Your final response must be based strictly on fresh external research fetched during this run. "
        "Specifically search for current 2026 data regarding the market landscape for AI-powered healthcare solutions, "
        "including key players, market size, and growth trends."
    ),
    expected_output="Comprehensive market data including key players, market size, and growth trends, citing live web data.",
    agent=researcher
)


analysis_task = Task(
    description="Analyze the market data and identify the top 3 investment opportunities",
    expected_output="Analysis report with 3 recommended investment opportunities and rationale",
    agent=analyst,
    context=[research_task]
)

# Create the crew
market_analysis_crew = Crew(
    agents=[researcher, analyst],
    tasks=[research_task, analysis_task],
    process=Process.sequential,
    verbose=True
)

# Run the crew
result = market_analysis_crew.kickoff()
