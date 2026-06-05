"""
An agent with multiple tasks
Recommended video: https://www.youtube.com/watch?v=I90xJlzAUW0

"""

from crewai import Agent, Task, Crew, LLM

# 1. Define the agent
research_and_summary_agent = Agent(
    role='Senior Research Specialist',
    goal='Gather data and summarize findings',
    backstory='You are an expert researcher with a knack for distilling complex information.',
    tools=[...]
)

# 2. Assign multiple tasks to the same agent
task1 = Task(
    description='Search the web for the latest advancements in AI.',
    expected_output='A list of 5 major AI breakthroughs this year.',
    agent=research_and_summary_agent
)

task2 = Task(
    description='Summarize the breakthroughs found in task 1 into a short paragraph.',
    expected_output='A 3-sentence summary of the breakthroughs.',
    agent=research_and_summary_agent
)

# 3. Create the crew and execute
my_crew = Crew(
    agents=[research_and_summary_agent],
    tasks=[task1, task2],
    verbose=True
)

result = my_crew.kickoff()
