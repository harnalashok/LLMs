"""
research_task modified.
But reply has hallucination
llama3.2 Model NOT good
Change the model to: granite4.1:8b
My folder: D:\Documents\OneDrive\Documents\crewai\python_based

"""


from crewai import Agent, Crew, Process, Task, LLM
# 1. Import the Serper/SerpAPI search tool
from crewai_tools import SerperDevTool

# 2. Initialize the search tool (Requires SERPER_API_KEY in your environment variables)
#    export SERPER_API_KEY="your_api_key_here"
#    export SERPER_API_KEY="c374574bf69fc2eeaa6a021831fe29e52ec3cd7a" 
search_tool = SerperDevTool()

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
