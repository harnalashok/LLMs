"""
# 19th May, 2026
Uses LLM's knowledge. 
No Internet access
# My folder: D:\Documents\OneDrive\Documents\crewai\python_based

"""

# 1.0 Necessary imports
from crewai import Agent, Crew, Process, Task,LLM


# 2. Define your local Ollama LLM configuration
local_llm = LLM(
                model="ollama/openhermes",        # Prefix with 'ollama/' followed by your model name
                base_url="http://localhost:11434" # Default Ollama local server URL
                )


# 3.Create specialized agents
# 3.1 Researcher agent
researcher = Agent(
                    role="Market Research Specialist",
                    goal="Find comprehensive market data on emerging technologies",
                    backstory="You are an expert at discovering market trends and gathering data.",
                    llm=local_llm,
                    verbose=True
                    )

# 3.2 Analyst agent
analyst = Agent(
                role="Market Analyst",
                goal="Analyze market data and identify key opportunities",
                backstory="You excel at interpreting market data and spotting valuable insights.",
                llm=local_llm,
                verbose=True
                )

# 4.0 Define their tasks
# 4.1 Task1
research_task = Task(
                    description="Research the current market landscape for AI-powered healthcare solutions",
                    expected_output="Comprehensive market data including key players, market size, and growth trends",
                    agent=researcher
                    )

# 4.2 Task2
analysis_task = Task(
                    description="Analyze the market data and identify the top 3 investment opportunities",
                    expected_output="Analysis report with 3 recommended investment opportunities and rationale",
                    agent=analyst,
                    context=[research_task]  # In sequential tasks, this is the default. But
                                             #  a task may access context from other or previous 
                                             #     tasks also.
                    )

# 5.0 Create the crew
market_analysis_crew = Crew(
                            agents=[researcher, analyst],
                            tasks=[research_task, analysis_task],
                            process=Process.sequential,
                            verbose=True
                            )

# 6.0 Run the crew
result = market_analysis_crew.kickoff()   # kickoff can also specify variable values

"""
How to procced in the recommended way:
1. Execute following commands:
    a. uv tool install crewai
    b. crewai create crew market_analysis_crew
    c. cd market_analysis_crew/
    d. Change description etc for agents.yaml and tasks,.yaml
       Preferably do NOT change names of agents/tasks.
       We do not have any variables here.
    e. crew.py file will NOT need any amendements if names are unchanged.
    f. In file, .env, change LLM model 
    g. main.py file will need amendments when there are different or NO inputs.
        The following code is sufficient:
        from datetime import datetime
        from market_analysis_crew.crew import MarketAnalysisCrew
        warnings.filterwarnings("ignore", category=SyntaxWarning, module="pysbd")
        
        def run():
            # Run the crew.
            MarketAnalysisCrew().crew().kickoff()

    h. Specify variables and values

        def run():
            # Run the crew.
            inputs = {
                    'topic': 'AI in Healthcare',
                    'current_year': '2024'
                     }
            MarketAnalysisCrew().crew().kickoff(inputs=inputs)

"""

