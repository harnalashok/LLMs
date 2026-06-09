# Ref: https://www.youtube.com/watch?v=tnejrr-0a94
from crewai import Agent, Task,Crew, Process,LLM
#rom langchain_community.llms import Ollama

# Define your Ollama model
ollama_llm = LLM(
    model="ollama/openhermes",        # Prefix with 'ollama/' followed by your model name
    base_url="http://localhost:11434" # Default Ollama local server URL
)

researcher = Agent(role = 'Researcher', 
                   goal = 'Perform thorough research on AI',
                   backstory = 'You are a diligent researcher with a passion for uncovering hidden insights and providing comprehensive analysis on AI.',
                   llm = ollama_llm,
                   verbose = True,
                   allow_delegation = False
                   )

blogWriter = Agent(role = "Blog Writer", 
                   goal = "Write a comprehensive blog post on the research findings about AI",
                   backstory = "A skilled writer with a knack for translating complex research findings into engaging and accessible blog posts.",
                   llm = ollama_llm,
                   verbose = True,
                   allow_delegation = False)


task1 = Task(
    description="Analyze the latest trends in AI.",
    expected_output="A summary report.",
    agent=researcher
    )


task2 = Task(
    description="Blog Writer Task.",
    expected_output="A Blog.",
    agent=blogWriter
    )



my_crew = Crew(
    agents=[researcher, blogWriter],
    tasks=[task1, task2],
    process=Process.sequential, # or Process.hierarchical
    verbose=True
)

# Start the crew
result = my_crew.kickoff(inputs={'topic': 'AI trends'})

print(result)
