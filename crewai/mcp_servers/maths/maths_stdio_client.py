
"""
# Last amended: 31st May, 2026
# Ref: https://github.com/tonykipkemboi/crewai-mcp-demo/tree/main
MCP Maths client
=====
    It connects to tools advertised locally
    by math_stdio_server.py. This file is in
    'servers' folder, below the current folder. 

"""

# 1.0
import os
from crewai import Agent, Task, Crew, LLM

# 2.0
from crewai_tools import MCPServerAdapter
from mcp import StdioServerParameters

# 3.0 Define local Ollama LLM configuration
local_llm = LLM(
                model="ollama/qwen3:latest",     # Prefix with 'ollama/' followed by your model name
                base_url="http://localhost:11434"   # Default Ollama local server URL
                )


# 4.0 Create a StdioServerParameters object
#    Note that mcp server DOES NOT have a port or a url:

server_params=StdioServerParameters(
    command="python3", 
    args=["servers/math_stdio_server.py"],
    env={"UV_PYTHON": "3.13", **os.environ},
)

# 5.0 Use the StdioServerParameters object to create a MCPServerAdapter
with MCPServerAdapter(server_params) as tools:
    print(f"Available tools from Stdio MCP server: {[tool.name for tool in tools]}")

    # 5.1
    agent = Agent(
        role="Mathematician",
        goal="Perform mathematical operations.",
        backstory="An experienced mathematician that can perform mathematical operations via MCP tools.",
        tools=tools,
        verbose=True,
        llm = local_llm,
        
    )
    
    # 5.2
    task = Task(
        description="Solve the math {problem} given to you by the user.",
        expected_output="The correct answer to the math problem using the available tools.",
        agent=agent,
    )
    
    # 5.3
    crew = Crew(
        agents=[agent],
        tasks=[task],
        verbose=True,
        tracing = True,
    )
    
    # 5.4
    result = crew.kickoff(inputs={"problem": "power(2.25, 2)"})
    
    # 5.5
    print(result)