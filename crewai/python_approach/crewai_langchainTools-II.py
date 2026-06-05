"""
# Last amended:  25th May, 2026
# My folder:
# Using PolygonFinancials tool from langchain
# About Polygon tools:
Question1: What does this tool do:
    https://github.com/langchain-ai/langchain-community/tree/7c10a5fa327f6aaaf7c932822a9e5d144891406e/libs/community/langchain_community/tools/polygon

    This tool is useful for fetching fundamental financials from
    balance sheets, income statements, and cash flow statements
    for a stock ticker. The input should be the ticker that you 
    want to get the latest fundamental financial data for

"""

import os
from langchain_community.tools.polygon.financials import PolygonFinancials
from langchain_community.utilities.polygon import PolygonAPIWrapper
from crewai import Agent, Crew, Process, Task,LLM
from crewai.tools import BaseTool
from pydantic import Field
from langchain_community.utilities.polygon import PolygonAPIWrapper


# 2. Define your local Ollama LLM configuration
local_llm = LLM(
                model="ollama/qwen3:latest",        # Prefix with 'ollama/' followed by your model name
                base_url="http://localhost:11434" # Default Ollama local server URL
                )


# 2.1 Store your secret Polygon.io authentication key in your system's 
#     environment variables. This allows financial and trading libraries
#     to securely access real-time stock and crypto data without hardcoding
#     the key into your script:

os.environ["POLYGON_API_KEY"] = "j0ZrkimZ53C1ZNx3cdtMXk0tE1pYL3Kx"

# 3. Initialize the wrapper and the specific tool
#    See Questions below for understanding this class
class PolygonFinancialsTool(BaseTool):
    name: str = "Polygon Financials"
    description: str = "Fetch financial data from Polygon."
    polygon: PolygonFinancials = Field(default_factory=lambda: PolygonFinancials(api_wrapper=PolygonAPIWrapper()))
            
    def _run(self, query: str) -> str:
        return self.polygon.run(query)



# 4. Pass it to your CrewAI agent:
researcher = Agent(
                    role='Financial Analyst',
                    goal='Retrieve and analyze company financial statements',
                    backstory='Expert financial analyst skilled in extracting data from market APIs.',
                    tools=[PolygonFinancialsTool()],
                    llm = local_llm,
                    verbose = True
                    )

# 5 Analyst agent
analyst = Agent(
                role="Market Analyst",
                goal="Analyze market data and identify key opportunities",
                backstory="You excel at interpreting market data and spotting valuable insights.",
                llm=local_llm,
                verbose=True
                )

# 6.0 Define their tasks
# 6.1 Task1
research_task = Task(
                    description="Research the current market landscape for NVDA",
                    expected_output="Comprehensive financial metrics",
                    agent=researcher
                    )

# 6.2 Task2
analysis_task = Task(
                    description="Analyze the financial data for NVDA",
                    expected_output="Bulleted Analysis report",
                    agent=analyst,
                    context=[research_task]  # In sequential tasks, this is the default. But
                                             #  a task may access context from other or previous 
                                             #     tasks also.
                    )

# 7.0 Create the crew
market_analysis_crew = Crew(
                            agents=[researcher, analyst],
                            tasks=[research_task, analysis_task],
                            process=Process.sequential,
                            verbose=True
                            )

# 7.1 Run the crew
result = market_analysis_crew.kickoff()   # kickoff can also specify variable values
print(result)

"""
Question 2: What is the role of lambda in the Class:

    lambda creates a lazy function. For example,
    the following does not execute 3 + 4 immediately
    x = lambda : 3 + 4
    print(x)    # Does not print 7
    x()         # This executes lambda

    So, the following:
    default_factory=PolygonFinancials(api_wrapper=PolygonAPIWrapper())
    would execute PolygonAPIWrapper() immediately instead for waiting for 
    Agent call. But,
    default_factory=lambda: PolygonFinancials(api_wrapper=PolygonAPIWrapper())
    executes only when default_factory is called.

Question 3: Is default_factory any name or a fixed name?

default_factory is a fixed name required by Python libraries 
like Pydantic and dataclasses. It is a specific configuration 
keyword that tells the system: "If the user doesn't provide a value 
for this field, run this specific function to generate the default value."

    When CrewAI initializes your agent and sets up the tool library:
    1. It reads your class template.
    2. It sees that api_tool is missing a default static value.
    3. It triggers the fixed keyword default_factory [2].
    4. The lambda function fires up, executing PolygonAPIWrapper() 
        freshly in isolated memory space, shielding your execution 
        loop from side-effects or multi-threading token cross-contamination.

Question 4: What is the difference between PolygonFinancials and PolygonAPIWrapper?

    The difference comes down to responsibility. PolygonAPIWrapper handles the technical 
    plumbing, while PolygonFinancials handles the business logic for the AI.
    Think of it like a restaurant: PolygonAPIWrapper is the kitchen doing the cooking,
    and PolygonFinancials is the waiter translating the menu for the customer (the AI agent).

Question 5: Why write as: PolygonFinancials(api_wrapper=PolygonAPIWrapper()) why not just as:
            PolygonFinancials(PolygonAPIWrapper())    

            Writing it as api_wrapper=PolygonAPIWrapper() uses keyword arguments, while writing 
            it as PolygonAPIWrapper() uses positional arguments.

Question 6: In 'from pydantic import Field', what is the role of Field?

            In Pydantic (and by extension, CrewAI), the Field function is
            used to add extra configuration, validation rules, and 
            descriptions to an object's variables

            While a standard Python type hint (like ticker: str) only 
            tells the system what kind of data to expect, Field allows 
            you to control how that data behaves, how the LLM sees it, 
            and how it is initialized.

            For example, Field lets you use 'default_factory' to safely 
            create fresh, isolated tool instances for your agents every 
            time the class is built, avoiding shared-state bugs.

            Field allows you to inject descriptions that act as direct
            prompts for the AI.

            Sometimes you need a variable in your class for technical 
            reasons (like an API key or database connection), but you 
            do not want the LLM to see it or try to manipulate it. 
            Field lets you hide it, as:

            api_key: str = Field(default="MY_SECRET_KEY", exclude=True)
            (it is 'dafault' not 'default_factory')

Question 7: How is pydantic different from python?

    Python is the core programming language itself, 
    while Pydantic is a library written in Python 
    specifically built to handle data validation and 
    settings management.

    Think of Python as the building materials 
    (wood, bricks, and pipes), and Pydantic as the 
    strict building inspector who ensures every piece 
    of material is the exact right size, shape, and 
    quality before it is used.

    Python supports "Type Hints" to let you know what
    data should be there, but it does not actually stop 
    you from making mistakes. Pydantic forces the rules 
    to be followed

    In standard Python: If you tell a class that an age 
    should be an integer, but you accidentally pass a 
    string like "twenty", Python will accept it anyway.
    This often causes your code to crash later on during 
    calculations.

    In Pydantic: The moment data enters the class, 
    Pydantic stops the program immediately, rejects the 
    bad data, and throws a clear error message explaining 
    exactly what went wrong.



"""