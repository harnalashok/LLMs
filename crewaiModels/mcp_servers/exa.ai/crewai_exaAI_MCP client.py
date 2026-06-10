"""
# Last amended: 30th MAy, 2026
# MCP Client file

# Connecting with MCP server at https://exa.ai/mcp
#  No need to install and exa.ai software.
#   Run up to 1,000 requests per month for free.
#     See below for a list of tools available.
#       Refer: https://github.com/exa-labs/exa-mcp-server
# 
# My folder: C:\Users\ashok\OneDrive\Documents\crewai\mcp_servers_examples
#
# More Examples: https://github.com/tonykipkemboi/crewai-mcp-demo/tree/main

"""

# 1.0
# uv pip install 'crewai-tools[mcp]'
from crewai import Agent, Task, Crew, LLM
from crewai_tools import MCPServerAdapter


# 2. Define your local Ollama LLM configuration
#    To work with MCP servers, we need better LLMs
local_llm = LLM(
                model="ollama/qwen3.5:latest",        # Prefix with 'ollama/' followed by your model name
                base_url="http://localhost:11434" # Default Ollama local server URL
                )

# MCP server exa.ai key
api_key = "ec0029cc-e2c1-6678-b5a8-13c0f525fbf2"

server_params = {"url": "https://mcp.exa.ai/mcp?api_key=ec0029cc-e2c1-4664-b5a8-13c0f525fbf2", \
                 "transport": "streamable-http" \
                }

#     Given 'server parameters', MCPServerAdapter 
#       connects to MCP server(s) and makes available
#        tools
# Ref: https://docs.crewai.com/en/mcp/multiple-servers 

with MCPServerAdapter(server_params) as mcp_tools:
    fetch_tool = [t for t in mcp_tools if t.name == "web_fetch_exa"][0]
    fetch_tool.result_as_answer = False

    research_agent = Agent(
        role="Research Analyst",
        goal="Fetch web pages with web_fetch_exa",
        backstory="Uses web_fetch_exa to retrieve URL https://en.wikipedia.org/wiki/Artificial_intelligence.",
        tools=[fetch_tool],
        verbose=True,
        llm = local_llm,
        max_iter=2,  # <-- stops after 2 iterations
    )
    task = Task(
     description=(
        "Use the 'web_fetch_exa' tool to fetch the URL https://en.wikipedia.org/wiki/Artificial_intelligence. "
        "Then summarize the fetched page content in 3 bullet points. "
        "You MUST call web_fetch_exa before answering."
    ),
    expected_output="3 bullet-point summary of https://en.wikipedia.org/wiki/Artificial_intelligence",
    agent=research_agent,
)
    crew = Crew(agents=[research_agent],
                 tasks=[task], 
                 verbose=True,
                 tracing=True 
                 )
    
    print(crew.kickoff())   # <-- MUST be inside `with

"""
Question 1: What is the implication of "transport": "streamable-http" ?

    "transport": "streamable-http" tells MCPServerAdapter how to communicate with the 
    remote MCP server. Specifically:

        It uses HTTP as the underlying protocol (vs. stdio for local processes)
        Supports both request-response and streaming patterns (via Server-Sent Events)
        Designed for remotely hosted MCP servers like mcp.exa.ai

    The alternative transports are:

        stdio — for local MCP servers running as a subprocess
        sse — older Server-Sent Events only transport

Question 2: Unfortunately the 'with MCPServerAdapter(server_params) as mcp_tools:' code gets into a 
loop executing fethching web page from the URL multiple times:

    The looping is caused by local_llm — weaker/local LLMs often can't 
    properly reason about when to stop calling a tool and produce a 
    final answer. This is a known issue with local models.

    Fixes to try:

    1. Set max_iter to limit loops:
        research_agent = Agent(
        role="Research Analyst",
        goal="Fetch web pages with web_fetch_exa",
        backstory="Uses web_fetch_exa to retrieve URLs.",
        tools=[fetch_tool],
        verbose=True,
        llm=local_llm,
        max_iter=2,  # <-- stops after 2 iterations
    
    2. Set 'fetch_tool.result_as_answer = True' as against False in the code
       above, to bypass LLM post-processing entirely.

    3. Switch to a stronger LLM (e.g. gpt-4o, claude-sonnet-3-5) — 
       local models frequently struggle with tool-call termination logic.    

Question 3: What is tracinh? How is it different from verbose?

    tracing in CrewAI provides comprehensive visibility into your AI workflows.
    It captures detailed execution data — agent reasoning, task outputs, 
    tool usage, LLM calls (with token usage and costs), and timing — so you 
    can debug, monitor performance, and understand exactly how your crew 
    arrived at its results.
    
    verbose=True: prints execution details (agent thoughts, tool calls, 
    outputs) to your terminal/console in real time. Local-only, ephemeral,
    text-based — good for live debugging.

    Tracing: captures structured execution data (LLM calls, tokens, costs,
    timings, tool usage, agent reasoning) and sends it to the CrewAI AMP 
    dashboard for visual inspection, historical review, and performance 
    monitoring.

Question 4: What tools are available with exa.ai mcp    

    Refer GitHub: https://github.com/exa-labs/exa-mcp-server
    The Exa MCP Server connects AI assistants (like Claude, Cursor, and Windsurf) 
    to Exa's search, code, and company research capabilities. Depending on your 
    configuration, it supports the following tools:

    web_search_exa: Performs real-time web searches and extracts clean, token-efficient 
                    content optimized for AI.
    web_search_advanced_exa: A powerful search with advanced filters for domains, data 
                    ranges, and subpages   
    crawling_exa: Extracts and reads the full text or contents of a specific URL 
                    (e.g., an article, blog post, or PDF)    
    company_research_exa: Gathers comprehensive business information, news, financial 
                    data, and insights by crawling company websites and resources.  
    people_search_exa: Finds people and searches for professional profiles and contacts
    deep_researcher_start: Triggers a smart AI research agent to thoroughly investigate
                    complex topics, read multiple sources, and begin assembling a 
                    detailed report.
    deep_researcher_check: Checks the status of an ongoing deep research task and 
                           retrieves the final comprehensive report.

"""    
    
    
