"""
# Last amended: 9th June, 2026
# Server is: servers/mcp_dirRead_server.py
# No need to start mcp server beforehand
#  client will start the stdio server when needed

# Reads specified directory using mcp stdio protocol
# The directory should have 'chmod +x 777' permissions.
# 

"""


# Server is: mcp_dirRead_client.py
from crewai import Agent, Task, Crew, Process, LLM
from crewai_tools import MCPServerAdapter
from mcp import StdioServerParameters
import os

server_params = StdioServerParameters(
                                        command="python3",
                                        args=["servers/mcp_dirRead_server.py"],  # So full command: python3 servers/mcp_dirRead_server.py
                                        env={"UV_PYTHON": "3.12", **os.environ},
                                    )


# 2. Define your local Ollama LLM configuration
local_llm = LLM(
                model="ollama/qwen2.5:latest",     # Prefix with 'ollama/' followed by your model name
                base_url="http://localhost:11434"   # Default Ollama local server URL
                )


with MCPServerAdapter(server_params) as tools:
    print(f"Available tools: {[tool.name for tool in tools]}")

    agent = Agent(
        role="File Analyst",
        goal="Read and summarize directory contents via MCP",
        backstory="An expert at navigating file systems using MCP tools.",
        tools=tools,
        verbose=True,
        llm = local_llm,
    )

    task = Task(
        description="Use the read_directory tool to list all files and summarize what's in the directory.",
        expected_output="A complete list and summary of files in the directory.",
        agent=agent,
    )

    crew = Crew(
        agents=[agent],
        tasks=[task],
        process=Process.sequential,
        verbose=True,
        tracing = True,
    )

    result = crew.kickoff()
    print("\nResult:\n", result)

    """
    Question 1: What does env={"UV_PYTHON": "3.12", **os.environ}, imply?

            The env parameter sets environment variables for the spawned 
            server process. Here's what each part means:
            "UV_PYTHON": "3.12" — tells uv (a Python package manager) to use 
            Python 3.12 when running the server script. This is relevant if 
            your server is launched via uv.
            **os.environ — spreads all current environment variables 
            (PATH, API keys, etc.) into the subprocess. This ensures the server
            process inherits your existing environment (e.g., so it can find 
            executables, access OPENAI_API_KEY, etc.).**
            Combined, it passes your full current environment plus explicitly
            pins the Python version for uv.

    Question 2: In the above answer, What does this mean: 'This is relevant if your 
                server is launched via uv.'

              The docs show UV_PYTHON: "3.12" as a convention in their examples, 
              but don't explicitly explain it further. In plain terms: uv is a fast
              Python package/project manager (alternative to pip/virtualenv). If your 
              server script is run using 'uv run mcp_dirRead_server.py' instead of 
              'python3 mcp_dirRead_server.py', the UV_PYTHON environment variable tells uv 
              which Python version to use.

             However, in the example, command="python3" is used directly — so UV_PYTHON
             may not have any effect here. It appears to be included as a precautionary 
             convention from the CrewAI docs, not a strict requirement.  
    
    Question 3: Do i need to start stdio mcp server before I run client or client on 
              its own will start stdio mcp server?

              The client starts the server automatically. You do not need to start it manually.
              With stdio transport, StdioServerParameters tells the client to spawn the server 
              as a subprocess using the command and args you provide. When the client runs, 
              it launches 'python3 mcp_dirRead_server.py' as a child process, communicates 
              with it via stdin/stdout, and shuts it down when done.
    
    """