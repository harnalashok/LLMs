# Last amended: 24th Sep, 2026
# This is MCP client
# MCP Servers used (TWO separate stdio servers):
#   1) technical_indicators_mcp_server.py  -> fetch_ohlcv, calculate_rsi, calculate_macd
#   2) alpaca_trading_mcpServer.py         -> get_account_info (and buy/sell/position tools, unused here)
#
# CrewAI Trading Agent — RSI & MACD Analysis + optional Account Info
#
# Five agent-task pairs:
#   Agent 1 / Task 1 : Fetch OHLCV data from Alpaca via MCP           (sequential, part of main crew)
#   Agent 2 / Task 2 : Calculate RSI from fetched data via MCP        (sequential, part of main crew)
#   Agent 3 / Task 3 : Calculate MACD from fetched data via MCP       (sequential, part of main crew)
#   Agent 4 / Task 4 : Analyse RSI + MACD results and write a buy/no-buy report   (main crew)
#   Agent 5 / Task 5 : Fetch Alpaca account info                      (SEPARATE crew, run only if the
#                                                                       user says yes at a human-input
#                                                                       prompt after the main crew finishes;
#                                                                       independent — no context passed in)
#
# Prerequisites
# -------------
#   uv add crewai crewai-tools mcp
#
#   export ALPACA_API_KEY="your_paper_key"
#   export ALPACA_SECRET_KEY="your_paper_secret"
#
# Usage
# -----
#   cd /home/ashok/crewai_pjt/mcp_servers/stock_trading
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

# 1.2 Path to the technical-indicators MCP server script
#     MCP server file need not be started beforehand
#       as we use stdio protocol. This client will start the server.
MCP_SERVER_PATH = "/home/ashok/crewai_pjt/mcp_servers/stock_trading/servers/technical_indicators_mcp_server.py"

# 1.2b Path to the Alpaca trading MCP server script (2nd, independent server)
ALPACA_MCP_SERVER_PATH = "/home/ashok/crewai_pjt/mcp_servers/alpaca/servers/alpaca_trading_mcpServer.py"


# 1.3. Define your local Ollama LLM configuration
local_llm = LLM(
                model="ollama/qwen3:latest",     # Prefix with 'ollama/' followed by your model name
                base_url="http://localhost:11434"   # Default Ollama local server URL
                )


# ============================================================
# 2.0 MCP Server connection — Technical Indicators
# Launches technical_indicators_mcp_server.py as a subprocess and
# exposes its three tools to the agents that need them.
# ============================================================
stdio_params = StdioServerParameters(
                                    command="python",
                                    args=[MCP_SERVER_PATH],
                                    env={
                                        **os.environ,        # pass through all env vars
                                        "ALPACA_API_KEY":    os.environ.get("ALPACA_API_KEY",    ""),
                                        "ALPACA_SECRET_KEY": os.environ.get("ALPACA_SECRET_KEY", ""),
                                        },
                                 )

# 2.1
# MCPServerAdapter wraps the stdio server and converts its tools
# into CrewAI-compatible tool objects.
# Ref: https://docs.crewai.com/en/mcp/multiple-servers

# 2.2 Spawn the server process & set up read/write streams
mcp_adapter = MCPServerAdapter(stdio_params)

# 2.3 Get list of available tools
mcp_tools   = mcp_adapter.tools   # list: [fetch_ohlcv, calculate_rsi, calculate_macd]

# 2.4 Tools in technical indictors

print("Technical-indicators tools:", [t.name for t in mcp_tools])


# ============================================================
# 2.5 MCP Server connection — Alpaca Trading (2nd, separate server)
# This is a DIFFERENT subprocess/server from the one above. We only
# need one tool from it here (get_account_info), but the adapter
# still exposes buy_stock / sell_stock / get_position / etc.
# ============================================================
alpaca_stdio_params = StdioServerParameters(
                                            command="python",
                                            args=[ALPACA_MCP_SERVER_PATH],
                                            env={
                                                **os.environ,
                                                "ALPACA_API_KEY":    os.environ.get("ALPACA_API_KEY",    ""),
                                                "ALPACA_SECRET_KEY": os.environ.get("ALPACA_SECRET_KEY", ""),
                                                },
                                         )

# 2.6 Spawn the Alpaca trading MCP server as a second, independent subprocess
alpaca_mcp_adapter = MCPServerAdapter(alpaca_stdio_params)

# 2.7 All tools this server exposes (buy_stock, sell_stock, get_position,
#     get_open_orders, cancel_all_orders, get_account_info)
alpaca_mcp_tools = alpaca_mcp_adapter.tools

print("Alpaca-trading tools:", [t.name for t in alpaca_mcp_tools])

# 2.8 We only want to hand Agent 5 the ONE tool it needs, not the whole
#     buy/sell toolbox — keeps this agent narrowly scoped to read-only info.
account_info_tool = next(t for t in alpaca_mcp_tools if t.name == "get_account_info")


# ============================================================
# 3.0 Agents
# ============================================================

# ------------------------------------------------------------
# AGENT-I
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
# AGENT-II
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
# AGENT-III
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
# AGENT-IV
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

# ------------------------------------------------------------
# AGENT-V
# 3.5 Account Info Agent
# Responsibility: call get_account_info on the Alpaca trading MCP
# server. Completely independent of Agents I-IV — runs (if at all)
# in its own separate crew, after a human-input prompt.
# ------------------------------------------------------------
account_info_agent = Agent(
                            role="Account Reporting Analyst",
                            goal=(
                                    "Retrieve and report the current Alpaca paper-trading account "
                                    "status: cash balance, buying power, and portfolio value."
                                  ),
                            backstory=(
                                        "You are a back-office analyst responsible for account "
                                        "reporting. You call the account-info tool and present the "
                                        "figures clearly, with no speculation or trading advice."
                                       ),
                            tools=[account_info_tool],
                            verbose=True,
                            llm = local_llm,
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
#      Receives RSI and MACD outputs as context automatically.
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

# ------------------------------------------------------------
# 4.5 Task 5: Report Account Info
# NOTE: no `context=[...]` at all — this task is deliberately
# independent of Tasks 1-4. It doesn't need or receive their output.
# ------------------------------------------------------------
task_get_account_info = Task(
    description=(
                "Call the get_account_info tool to retrieve the current Alpaca "
                "paper-trading account status. Report the cash balance, buying "
                "power, and total portfolio value in a short, clearly formatted "
                "summary. Do not comment on trading strategy or make recommendations."
                ),
    expected_output=(
                    "A short summary listing cash, buying power, and portfolio value."
                    ),
    agent=account_info_agent,
    # context intentionally omitted — independent of the other 4 tasks
)


# ============================================================
# 5.0 Crews
# Two separate crews: the main 4-agent analysis crew runs first and
# always. The account-info crew (Agent 5 / Task 5) is built but only
# kicked off if the user opts in at the human-input prompt below.
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

# 5.1 Separate, single-agent crew for the account-info step.
#     Kept apart from trading_crew so it can be skipped entirely
#     without touching the main crew's agents/tasks/process.
account_info_crew = Crew(
                        agents=[account_info_agent],
                        tasks=[task_get_account_info],
                        process=Process.sequential,
                        verbose=True,
                    )


# ============================================================
# 6.0 Entry point
# ============================================================
if __name__ == "__main__":
    try:
        print(f"\n{'='*60}")
        print(f"  Trading Analysis Crew — {SYMBOL}")
        print(f"  Lookback: {LOOKBACK_DAYS} days  |  Timeframe: {TIMEFRAME}")
        print(f"{'='*60}\n")

        result = trading_crew.kickoff()

        print(f"\n{'='*60}")
        print("  FINAL REPORT")
        print(f"{'='*60}\n")
        print(result)

        # --------------------------------------------------------
        # 6.1 Human-input gate for Agent 5 / Task 5.
        # Runs only after the main crew finishes, and only if the
        # user opts in. Agent 5 is otherwise never invoked.
        # --------------------------------------------------------
        print(f"\n{'='*60}")
        answer = input("Do you want to view Alpaca account information? [y/N]: ").strip().lower()

        if answer == "y":
            print(f"\n{'='*60}")
            print("  ACCOUNT INFORMATION")
            print(f"{'='*60}\n")

            account_result = account_info_crew.kickoff()

            print(f"\n{'='*60}")
            print("  ACCOUNT INFO REPORT")
            print(f"{'='*60}\n")
            print(account_result)
        else:
            print("Skipping account information step. Done.")

    finally:
        # Cleanly shut down both MCP server subprocesses on exit,
        # whether or not the account-info step ran.
        mcp_adapter.stop()
        alpaca_mcp_adapter.stop()

"""
Question 1: Can I put crew.kickoff() in a for loop to evaluate, say,
             performance of multiple stocks in a portfolio?

Answer: Yes — and there's actually a built-in method for this:
        kickoff_for_each(). Instead of a manual for loop, you can
        pass a list of inputs (e.g., one dict per stock):

        inputs = [
            {"stock": "AAPL"},
            {"stock": "TSLA"},
            {"stock": "MSFT"},
        ]
        results = my_crew.kickoff_for_each(inputs=inputs)

    This runs the crew sequentially for each item. For parallel execution,
      use akickoff_for_each() native async) or kickoff_for_each_async()
      (thread-based).

Question 2: Why is Agent 5 / Task 5 built as its own separate Crew
            instead of just appending it to trading_crew's agents/tasks list?

Answer: Two reasons:
  1. It needs to be conditionally skippable based on human input given
     AFTER the main crew already finished — CrewAI's per-task
     `human_input=True` flag pauses *during* a run to validate output,
     it doesn't let you decide beforehand whether a task runs at all.
     A plain Python if/input() around a second `.kickoff()` call is the
     simplest way to make an entire agent+task truly optional.
  2. It touches a second MCP server (alpaca_trading_mcpServer.py) that
     has nothing to do with the technical-indicators server the first
     four agents use, and it needs no context from them — keeping it
     in its own Crew keeps that separation explicit in the code.
"""
