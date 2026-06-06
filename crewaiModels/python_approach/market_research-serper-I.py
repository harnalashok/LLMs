
"""
Last amended: 19th May, 2026
My folder: D:\Documents\OneDrive\Documents\crewai\python_based
Inspite of serper API key, uses LLM's pretrained data.
Agent is not smart. Also task is not that clear.
export SERPER_API_KEY="c374574bf69fc2eeaa6a021831fe29e52ec3cd7a"

"""

from crewai import Agent, Crew, Process, Task, LLM

# 1. Import the Serper/SerpAPI search tool
from crewai_tools import SerperDevTool

# 2. Initialize the search tool (Requires SERPER_API_KEY in your
#      environment variables)

#    export SERPER_API_KEY="your_api_key_here"
search_tool = SerperDevTool()


# 3. Define your local Ollama LLM configuration
local_llm = LLM(
                model="ollama/qwen3:latest",     # Prefix with 'ollama/' followed by your model name
                base_url="http://localhost:11434"   # Default Ollama local server URL
                )


# 4.0 Create specialized agents


# 4.1
researcher = Agent(
                    role="Market Research Specialist",
                    goal="Find comprehensive market data on emerging technologies",
                    backstory="You are an expert at discovering market trends and gathering data.",
                    tools=[search_tool],
                    llm=local_llm,
                    verbose=True
                    )

# 4.2
analyst = Agent(
                role="Market Analyst",
                goal="Analyze market data and identify key opportunities",
                backstory="You excel at interpreting market data and spotting valuable insights.",
                llm=local_llm,
                # The analyst focuses on synthesis, so they don't necessarily need the search tool
                verbose=True
                )

# 5.0 Define their tasks
# 5.1
research_task = Task(
                    description="Research the current market landscape for AI-powered healthcare solutions. Use your search tool to find recent 2026 data.",
                    expected_output="Comprehensive market data including key players, market size, and growth trends",
                    agent=researcher
                    )

# 5.2
analysis_task = Task(
                    description="Analyze the market data and identify the top 3 investment opportunities",
                    expected_output="Analysis report with 3 recommended investment opportunities and rationale",
                    agent=analyst,
                    context=[research_task]
                    )

# 6.0 Create the crew
market_analysis_crew = Crew(
                            agents=[researcher, analyst],
                            tasks=[research_task, analysis_task],
                            process=Process.sequential,
                            verbose=True
                            )   

# 7.0 Run the crew
result = market_analysis_crew.kickoff()


"""
How to procced in the recommended way:
All steps are same. But read on Step2.

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

2. Specifying SerperDev tool:
   
    a. In crew.py, add the following line:
    
        from crewai_tools import SerperDevTool
        

        # Then in the same file, modify the requisite agent file as:
        
        @agent
        def researcher(self) -> Agent:
            return Agent(
                config=self.agents_config['researcher'], # type: ignore[index]
                verbose=True,
                tools=[SerperDevTool()] 
            )
    b. In .env file, add API key of Serper (without any inverted ommas):

       SERPER_API_KEY=xyz     

    Done.

"""

