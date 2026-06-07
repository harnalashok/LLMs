# MCP Server: technical_indicators_mcp.py
# Folder: /home/ashok/finance_pjt/
# CrewAI Trading Agent — RSI & MACD Analysis
#
# Four agent-task pairs (run sequentially):
#   Agent 1 / Task 1 : Fetch OHLCV data from Alpaca via MCP
#   Agent 2 / Task 2 : Calculate RSI from fetched data via MCP
#   Agent 3 / Task 3 : Calculate MACD from fetched data via MCP
#   Agent 4 / Task 4 : Analyse RSI + MACD results and write a buy/no-buy report
#
# Prerequisites
# -------------
#   pip install crewai crewai-tools mcp
#
#   export ALPACA_API_KEY="your_alpaca_key"
#   export ALPACA_SECRET_KEY="your_alpaca_secret"
#   export OPENAI_API_KEY="your_openai_key"   # or set llm= to another provider
#
# Usage
# -----
#   python trading_crew.py                    # analyses AAPL by default
#   python trading_crew.py TSLA               # pass any ticker as argv[1]

# ============================================================
# 0.0 Imports
# ============================================================
import sys
import os

from crewai import Agent, Task, Crew, Process, LLM
from crewai_tools import MCPServerAdapter
from mcp import StdioServerParameters

# ============================================================
# 1.0 Configuration
# ============================================================

# 1.1 Stock symbol — override via command-line argument
SYMBOL        = sys.argv[1].upper() if len(sys.argv) > 1 else "AAPL"
LOOKBACK_DAYS = 180      # calendar days of OHLCV history to fetch
TIMEFRAME     = "1Day"   # Alpaca bar size

# 1.2 Path to the MCP server script
#     Adjust this path if trading_crew.py and technical_indicators_mcp.py
#     live in different directories.
MCP_SERVER_PATH = "/home/ashok/finance_pjt/servers/technical_indicators_mcp.py"


# 1.3. Define your local Ollama LLM configuration
local_llm = LLM(
                model="ollama/qwen3:latest",     # Prefix with 'ollama/' followed by your model name
                base_url="http://localhost:11434"   # Default Ollama local server URL
                )




# ============================================================
# 2.0 MCP Server connection
# Launches technical_indicators_mcp.py as a subprocess and
# exposes its three tools to all agents that need them.
# ============================================================
mcp_params = StdioServerParameters(
    command="python",
    args=[MCP_SERVER_PATH],
    env={
        **os.environ,                          # pass through all env vars
        "ALPACA_API_KEY":    os.environ.get("ALPACA_API_KEY",    ""),
        "ALPACA_SECRET_KEY": os.environ.get("ALPACA_SECRET_KEY", ""),
    },
)

# 2.1
# MCPServerAdapter wraps the MCP server and converts its tools
# into CrewAI-compatible tool objects.
mcp_adapter = MCPServerAdapter(mcp_params)
mcp_tools   = mcp_adapter.tools   # list: [fetch_ohlcv, calculate_rsi, calculate_macd]

# ============================================================
# 3.0 Agents
# ============================================================

# ------------------------------------------------------------
# 3.1 Data Fetcher Agent
# Responsibility: call fetch_ohlcv and confirm data arrived.
# ------------------------------------------------------------
data_fetcher_agent = Agent(
    role="Market Data Fetcher",
    goal=(
        "Fetch historical OHLCV (Open, High, Low, Close, Volume) price data "
        f"for {SYMBOL} from Alpaca paper trading so that downstream agents "
        "can compute technical indicators."
    ),
    backstory=(
        "You are a specialist in retrieving financial market data. "
        "You connect to brokerage APIs, validate the returned data, "
        "and pass clean summaries to quantitative analysts."
    ),
    tools=mcp_tools,
    verbose=True,
    llm = local_llm,
)

# ------------------------------------------------------------
# 3.2 RSI Analyst Agent
# Responsibility: call calculate_rsi and interpret the result.
# ------------------------------------------------------------
rsi_agent = Agent(
    role="RSI Technical Analyst",
    goal=(
        f"Calculate the 14-period Relative Strength Index (RSI) for {SYMBOL} "
        "using the OHLCV data already loaded into the MCP server cache, "
        "and interpret whether the stock is overbought, oversold, or neutral."
    ),
    backstory=(
        "You are a quantitative analyst who specialises in momentum indicators. "
        "You compute RSI values, understand Wilder's smoothing method, and can "
        "clearly explain what the RSI reading means for trading decisions."
    ),
    tools=mcp_tools,
    verbose=True,
    llm = local_llm,
)

# ------------------------------------------------------------
# 3.3 MACD Analyst Agent
# Responsibility: call calculate_macd and interpret the result.
# ------------------------------------------------------------
macd_agent = Agent(
    role="MACD Technical Analyst",
    goal=(
        f"Calculate the MACD (12/26/9) for {SYMBOL} using the OHLCV data "
        "already loaded into the MCP server cache, and interpret the MACD line, "
        "signal line, histogram, and any crossover signal."
    ),
    backstory=(
        "You are a quantitative analyst who specialises in trend-following "
        "indicators. You compute MACD values, understand EMA mathematics, and "
        "can clearly explain what the MACD reading means for trading decisions."
    ),
    tools=mcp_tools,
    verbose=True,
    llm = local_llm,
)

# ------------------------------------------------------------
# 3.4 Strategy Analyst Agent
# Responsibility: synthesise RSI + MACD findings into a report.
# No MCP tools needed — this agent reasons over text context only.
# ------------------------------------------------------------
strategy_agent = Agent(
    role="Trading Strategy Analyst",
    goal=(
        f"Analyse the RSI and MACD findings for {SYMBOL} produced by the "
        "previous agents and write a structured research report with a clear "
        "BUY or NO BUY recommendation backed by technical reasoning."
    ),
    backstory=(
        "You are a senior portfolio manager with deep expertise in technical "
        "analysis. You synthesise multiple indicator signals, weigh conflicting "
        "evidence, manage risk, and communicate recommendations clearly to "
        "both technical and non-technical audiences."
    ),
    tools=[],    # pure reasoning — no MCP calls needed
    verbose=True,
    llm= local_llm,
)

# ============================================================
# 4.0 Tasks
# ============================================================

# ------------------------------------------------------------
# 4.1 Task 1: Fetch OHLCV data
# ------------------------------------------------------------
task_fetch_ohlcv = Task(
    description=(
        f"Use the fetch_ohlcv tool to retrieve {LOOKBACK_DAYS} calendar days "
        f"of daily OHLCV bars for stock symbol '{SYMBOL}' from Alpaca paper "
        f"trading (timeframe='{TIMEFRAME}'). "
        "Confirm the fetch succeeded by reporting: "
        "  • The symbol fetched "
        "  • Date range covered (start → end) "
        "  • Total number of bars returned "
        "  • The first 3 bars as a sample "
        "This data will be consumed by the RSI and MACD agents."
    ),
    expected_output=(
        "A confirmation summary stating the symbol, date range, bar count, "
        "and a 3-row OHLCV sample. No indicator values yet."
    ),
    agent=data_fetcher_agent,
)

# ------------------------------------------------------------
# 4.2 Task 2: Calculate RSI
# (context=[task_fetch_ohlcv] ensures this runs after Task 1)
# ------------------------------------------------------------
task_calculate_rsi = Task(
    description=(
        f"The OHLCV data for {SYMBOL} has been loaded into the MCP server cache "
        "by the Data Fetcher agent. "
        "Use the calculate_rsi tool with the default 14-period window. "
        "Report: "
        "  • The exact RSI value "
        "  • The signal classification (Overbought / Oversold / Neutral) "
        "  • The latest closing price "
        "  • The date the RSI was computed as of "
        "  • A one-paragraph interpretation of what this RSI reading implies "
        "    for short-term momentum."
    ),
    expected_output=(
        "RSI value, signal label, closing price, date, and a short "
        "momentum interpretation paragraph."
    ),
    agent=rsi_agent,
    context=[task_fetch_ohlcv],
)

# ------------------------------------------------------------
# 4.3 Task 3: Calculate MACD
# (context=[task_fetch_ohlcv] ensures this runs after Task 1)
# ------------------------------------------------------------
task_calculate_macd = Task(
    description=(
        f"The OHLCV data for {SYMBOL} has been loaded into the MCP server cache "
        "by the Data Fetcher agent. "
        "Use the calculate_macd tool with standard parameters (12/26/9). "
        "Report: "
        "  • MACD line value "
        "  • Signal line value "
        "  • Histogram value "
        "  • Crossover status (Bullish / Bearish / None) "
        "  • The latest closing price "
        "  • The date the MACD was computed as of "
        "  • A one-paragraph interpretation of what these MACD readings imply "
        "    for trend direction and momentum."
    ),
    expected_output=(
        "MACD line, signal line, histogram, crossover status, closing price, "
        "date, and a short trend interpretation paragraph."
    ),
    agent=macd_agent,
    context=[task_fetch_ohlcv],
)

# ------------------------------------------------------------
# 4.4 Task 4: Write the Trading Report
# Receives RSI and MACD outputs as context automatically.
# ------------------------------------------------------------
task_write_report = Task(
    description=(
        f"You have received the RSI analysis and the MACD analysis for {SYMBOL} "
        "from the previous agents. "
        "Write a structured trading research report with the following sections:\n\n"
        "1. EXECUTIVE SUMMARY\n"
        "   State the stock symbol, analysis date, and final recommendation "
        "   (BUY or NO BUY) in 2–3 sentences.\n\n"
        "2. RSI FINDINGS\n"
        "   Summarise the RSI value, signal, and what it implies for momentum.\n\n"
        "3. MACD FINDINGS\n"
        "   Summarise the MACD line, signal line, histogram, crossover, and "
        "   what they imply for trend direction.\n\n"
        "4. COMBINED SIGNAL ANALYSIS\n"
        "   Discuss whether RSI and MACD are in agreement or conflict. "
        "   Weigh the evidence:\n"
        "     • Both bullish  → Strong BUY signal\n"
        "     • Both bearish  → Strong NO BUY signal\n"
        "     • Mixed signals → Cautious / conditional stance, explain why\n\n"
        "5. RECOMMENDATION\n"
        "   Clearly state BUY or NO BUY with supporting rationale. "
        "   Include any risk caveats (e.g. confirm with volume, fundamentals, "
        "   macro context).\n\n"
        "6. DISCLAIMER\n"
        "   Standard disclaimer that this is a technical analysis only and "
        "   not financial advice."
    ),
    expected_output=(
        "A fully structured trading report with all six sections, ending with "
        "a clear BUY or NO BUY recommendation and a disclaimer."
    ),
    agent=strategy_agent,
    context=[task_calculate_rsi, task_calculate_macd],
)

# ============================================================
# 5.0 Crew
# ============================================================
trading_crew = Crew(
    agents=[
        data_fetcher_agent,
        rsi_agent,
        macd_agent,
        strategy_agent,
    ],
    tasks=[
        task_fetch_ohlcv,
        task_calculate_rsi,
        task_calculate_macd,
        task_write_report,
    ],
    process=Process.sequential,   # Tasks run in the order listed above
    verbose=True,
)

# ============================================================
# 6.0 Entry point
# ============================================================
if __name__ == "__main__":
    print(f"\n{'='*60}")
    print(f"  Trading Analysis Crew — {SYMBOL}")
    print(f"  Lookback: {LOOKBACK_DAYS} days  |  Timeframe: {TIMEFRAME}")
    print(f"{'='*60}\n")

    result = trading_crew.kickoff()

    print(f"\n{'='*60}")
    print("  FINAL REPORT")
    print(f"{'='*60}\n")
    print(result)
    
"""
Question 1: Can I put crew.kickoff() in a for loop to evaluate, say,
          sperformance of multiple stocks in a portfolio?
          
Answer: Yes — and there's actually a built-in method for this:
        kickoff_for_each(). Instead of a manual for loop, you can 
        pass a list of inputs (e.g., one dict per stock): 

        inputs = [
            {"stock": "AAPL"},
            {"stock": "TSLA"},
            {"stock": "MSFT"},
        ]
        results = my_crew.kickoff_for_each(inputs=inputs)   

    This runs the crew sequentially for each item. For parallel execution, use akickoff_for_each() native async) or kickoff_for_each_async() (thread-based).        

"""    
