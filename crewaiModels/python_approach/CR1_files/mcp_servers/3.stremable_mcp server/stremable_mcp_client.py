"""
# Last amended: 8th June, 2026
# Client to MCP server: mcp_stremable_server.py
# Execute it in VSCoder once the server is started
# in a terminal.

Ref: https://github.com/tonykipkemboi/crewai-mcp-demo/blob/main/script_approach_examples/streamable_http_client_demo.py

"""
# 1.0
from crewai import Agent, Task, Crew, LLM
from crewai_tools import MCPServerAdapter

# 1.1 Create a StreamableHTTPServerParameters object
server_params = {
                "url": "http://localhost:8001/mcp", 
                "transport": "streamable-http"
                }


# 2. Define your local Ollama LLM configuration
local_llm = LLM(
                model="ollama/llama3.2:latest",     # Prefix with 'ollama/' followed by your model name
                base_url="http://localhost:11434"   # Default Ollama local server URL
                )




# 3.0 Use the StreamableHTTPServerParameters:
#     Given 'server parameters', MCPServerAdapter 
#       connects to MCP server(s) and makes available
#        tools
# Ref: https://docs.crewai.com/en/mcp/multiple-servers 

with MCPServerAdapter(server_params) as tools:
    print("Available MCP Tools:", [tool.name for tool in tools])

    # 3.1
    doc_agent = Agent(
                    role="Hello World",
                    goal="Greet the user.",
                    backstory="A helpful assistant for greeting users.",
                    tools=tools,
                    llm = local_llm,
                    verbose=True
                    )

    # 3.2
    doc_task = Task(
                    description="Greet the {user}.",
                    agent=doc_agent,
                    expected_output="A very friendly greeting to the {user}.",
                    markdown=True
                 )

    # 3.3
    crew = Crew(
                agents=[doc_agent],
                tasks=[doc_task],
                verbose=True,
                tracing = True,
                )

    # 4.0
    # crew.kickoff gets input from user:
    #  The input() function in Python pauses your program 
    #   and lets the user type text using their keyboard. 
    #    Once the user presses the Enter key, the program 
    #     passes that value to a variable.
    # Syntax: { variable : input("message") }
    
    result = crew.kickoff(inputs={"user": input("I'll say hello to you if you say your name. What's your name? ") })
    print("\nFinal Output:\n", result)