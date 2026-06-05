# trading_crew.py
# CrewAI Trading Agent — RSI & MACD Analysis + Alpaca Paper Trading Execution
#
# Five agent-task pairs (run sequentially):
#   Agent 1 / Task 1 : Fetch OHLCV data from Alpaca via MCP
#   Agent 2 / Task 2 : Calculate RSI from fetched data via MCP
#   Agent 3 / Task 3 : Calculate MACD from fetched data via MCP
#   Agent 4 / Task 4 : Analyse RSI + MACD and write a BUY / NO BUY report
#   Agent 5 / Task 5 : Execute a $1,000 market order on Alpaca paper trading
#                      (only fires if Task 4 recommended BUY)
#
# Prerequisites
# -------------
#   pip install crewai crewai-tools mcp requests
#
#   export ALPACA_API_KEY="your_alpaca_key"
#   export ALPACA_SECRET_KEY="your_alpaca_secret"
#   export OPENAI_API_KEY="your_openai_key"
#
# Usage
# -----
#   python trading_crew.py            # analyses AAPL by default
#   python trading_crew.py TSLA       # pass any ticker as argv[1]

# ============================================================
# 0.0 Imports
# ============================================================
import sys
import os
import re
import json
import requests
from datetime import datetime

from crewai import Agent, Task, Crew, Process
from crewai.tools import tool
from crewai_tools import MCPServerAdapter
from mcp import StdioServerParameters

# ============================================================
# 1.0 Configuration
# ============================================================

# 1.1 Stock symbol — override via command-line argument
SYMBOL        = sys.argv[1].upper() if len(sys.argv) > 1 else "AAPL"
LOOKBACK_DAYS = 180       # calendar days of OHLCV history to fetch
TIMEFRAME     = "1Day"    # Alpaca bar size

# 1.2 Paper trading execution settings
TRADE_NOTIONAL = 1000.0   # fixed dollar amount per trade (USD)

# 1.3 Alpaca endpoints
#     Data feed  — used by technical_indicators_mcp.py
#     Trading    — used by the execution agent below
ALPACA_TRADING_URL = "https://paper-api.alpaca.markets/v2"

ALPACA_API_KEY    = os.environ.get("ALPACA_API_KEY",    "")
ALPACA_SECRET_KEY = os.environ.get("ALPACA_SECRET_KEY", "")

ALPACA_HEADERS = {
    "APCA-API-KEY-ID":     ALPACA_API_KEY,
    "APCA-API-SECRET-KEY": ALPACA_SECRET_KEY,
    "Content-Type":        "application/json",
}

# 1.4 Path to the MCP server script
MCP_SERVER_PATH = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "technical_indicators_mcp.py",
)

# ============================================================
# 2.0 MCP Server connection (for Tools 1-3: data + indicators)
# ============================================================
mcp_params = StdioServerParameters(
    command="python",
    args=[MCP_SERVER_PATH],
    env={
        **os.environ,
        "ALPACA_API_KEY":    ALPACA_API_KEY,
        "ALPACA_SECRET_KEY": ALPACA_SECRET_KEY,
    },
)

mcp_adapter = MCPServerAdapter(mcp_params)
mcp_tools   = mcp_adapter.tools   # [fetch_ohlcv, calculate_rsi, calculate_macd]

# ============================================================
# 3.0 Paper Trading Tool (native CrewAI tool — no MCP needed)
# ============================================================

@tool("place_paper_trade")
def place_paper_trade(symbol: str, notional: float) -> str:
    """
    Place a market BUY order on Alpaca paper trading for the given symbol
    using a fixed notional (dollar) amount.

    Parameters
    ----------
    symbol   : Stock ticker to buy (e.g. "AAPL")
    notional : Dollar amount to spend (e.g. 1000.0)

    Returns
    -------
    JSON string with the full Alpaca order response, including:
        id, client_order_id, symbol, side, type, status,
        notional, filled_qty, filled_avg_price, submitted_at
    """
    # 3.1 Verify we have API credentials before hitting the endpoint
    if not ALPACA_API_KEY or not ALPACA_SECRET_KEY:
        return json.dumps({
            "error": "Missing ALPACA_API_KEY or ALPACA_SECRET_KEY environment variables."
        })

    # 3.2 Check account status before placing order
    acct_resp = requests.get(
        f"{ALPACA_TRADING_URL}/account",
        headers=ALPACA_HEADERS,
        timeout=10,
    )
    acct_resp.raise_for_status()
    account = acct_resp.json()

    if account.get("trading_blocked") or account.get("account_blocked"):
        return json.dumps({"error": "Alpaca account is blocked. Cannot place order."})

    buying_power = float(account.get("buying_power", 0))
    if buying_power < notional:
        return json.dumps({
            "error": (
                f"Insufficient buying power. "
                f"Required: ${notional:,.2f} | Available: ${buying_power:,.2f}"
            )
        })

    # 3.3 Build and submit the market order using notional dollars
    #     Fractional / notional orders are supported on Alpaca paper trading.
    order_payload = {
        "symbol":        symbol.upper(),
        "notional":      str(round(notional, 2)),  # Alpaca expects a string
        "side":          "buy",
        "type":          "market",
        "time_in_force": "day",                    # day order; fills at open
    }

    order_resp = requests.post(
        f"{ALPACA_TRADING_URL}/orders",
        headers=ALPACA_HEADERS,
        json=order_payload,
        timeout=10,
    )
    order_resp.raise_for_status()
    order = order_resp.json()

    # 3.4 Return a clean subset of the order confirmation
    result = {
        "status":           "ORDER PLACED",
        "order_id":         order.get("id"),
        "client_order_id":  order.get("client_order_id"),
        "symbol":           order.get("symbol"),
        "side":             order.get("side"),
        "type":             order.get("type"),
        "order_status":     order.get("status"),
        "notional":         order.get("notional"),
        "filled_qty":       order.get("filled_qty"),
        "filled_avg_price": order.get("filled_avg_price"),
        "submitted_at":     order.get("submitted_at"),
        "buying_power_before": f"${buying_power:,.2f}",
    }
    return json.dumps(result, indent=2)


# ============================================================
# 4.0 Agents
# ============================================================

# ------------------------------------------------------------
# 4.1 Data Fetcher Agent
# ------------------------------------------------------------
data_fetcher_agent = Agent(
    role="Market Data Fetcher",
    goal=(
        f"Fetch historical OHLCV price data for {SYMBOL} from Alpaca "
        "paper trading so downstream agents can compute technical indicators."
    ),
    backstory=(
        "You are a specialist in retrieving financial market data. "
        "You connect to brokerage APIs, validate the returned data, "
        "and pass clean summaries to quantitative analysts."
    ),
    tools=mcp_tools,
    verbose=True,
)

# ------------------------------------------------------------
# 4.2 RSI Analyst Agent
# ------------------------------------------------------------
rsi_agent = Agent(
    role="RSI Technical Analyst",
    goal=(
        f"Calculate the 14-period RSI for {SYMBOL} from the cached OHLCV data "
        "and interpret whether the stock is overbought, oversold, or neutral."
    ),
    backstory=(
        "You are a quantitative analyst who specialises in momentum indicators. "
        "You compute RSI values using Wilder's smoothing and clearly explain "
        "what the reading means for trading decisions."
    ),
    tools=mcp_tools,
    verbose=True,
)

# ------------------------------------------------------------
# 4.3 MACD Analyst Agent
# ------------------------------------------------------------
macd_agent = Agent(
    role="MACD Technical Analyst",
    goal=(
        f"Calculate MACD (12/26/9) for {SYMBOL} from the cached OHLCV data "
        "and interpret the MACD line, signal line, histogram, and crossover."
    ),
    backstory=(
        "You are a quantitative analyst who specialises in trend-following "
        "indicators. You compute MACD values and clearly explain what they "
        "mean for trend direction and trading decisions."
    ),
    tools=mcp_tools,
    verbose=True,
)

# ------------------------------------------------------------
# 4.4 Strategy Analyst Agent
# ------------------------------------------------------------
strategy_agent = Agent(
    role="Trading Strategy Analyst",
    goal=(
        f"Analyse the RSI and MACD findings for {SYMBOL} and write a structured "
        "research report with a clear BUY or NO BUY recommendation. "
        "Your final output MUST contain exactly one of these two strings on its "
        "own line: 'FINAL DECISION: BUY' or 'FINAL DECISION: NO BUY'. "
        "This line is machine-parsed to trigger execution."
    ),
    backstory=(
        "You are a senior portfolio manager with deep expertise in technical "
        "analysis. You synthesise multiple indicator signals, weigh conflicting "
        "evidence, and communicate recommendations clearly."
    ),
    tools=[],
    verbose=True,
)

# ------------------------------------------------------------
# 4.5 Trade Execution Agent
# ------------------------------------------------------------
execution_agent = Agent(
    role="Paper Trade Execution Agent",
    goal=(
        "Read the strategy report from the previous agent. "
        "If and only if it contains 'FINAL DECISION: BUY', use the "
        f"place_paper_trade tool to buy ${TRADE_NOTIONAL:,.0f} worth of {SYMBOL} "
        "on Alpaca paper trading. "
        "If the decision is NO BUY, do NOT call the tool — just report that "
        "no trade was placed and explain why."
    ),
    backstory=(
        "You are an algorithmic execution specialist. You read structured "
        "research reports, extract the trading decision, and route orders "
        "to the brokerage API. You are disciplined: you never place a trade "
        "unless the report explicitly says BUY."
    ),
    tools=[place_paper_trade],
    verbose=True,
)

# ============================================================
# 5.0 Tasks
# ============================================================

# ------------------------------------------------------------
# 5.1 Task 1: Fetch OHLCV data
# ------------------------------------------------------------
task_fetch_ohlcv = Task(
    description=(
        f"Use the fetch_ohlcv tool to retrieve {LOOKBACK_DAYS} calendar days "
        f"of daily OHLCV bars for '{SYMBOL}' from Alpaca paper trading "
        f"(timeframe='{TIMEFRAME}'). "
        "Confirm success by reporting: symbol, date range, bar count, "
        "and the first 3 bars as a sample."
    ),
    expected_output=(
        "Confirmation with symbol, date range, bar count, and a 3-row "
        "OHLCV sample. No indicator values yet."
    ),
    agent=data_fetcher_agent,
)

# ------------------------------------------------------------
# 5.2 Task 2: Calculate RSI
# ------------------------------------------------------------
task_calculate_rsi = Task(
    description=(
        f"OHLCV data for {SYMBOL} is cached. Use calculate_rsi (period=14). "
        "Report: RSI value, signal (Overbought/Oversold/Neutral), latest close, "
        "date, and a one-paragraph momentum interpretation."
    ),
    expected_output=(
        "RSI value, signal label, closing price, date, and a momentum "
        "interpretation paragraph."
    ),
    agent=rsi_agent,
    context=[task_fetch_ohlcv],
)

# ------------------------------------------------------------
# 5.3 Task 3: Calculate MACD
# ------------------------------------------------------------
task_calculate_macd = Task(
    description=(
        f"OHLCV data for {SYMBOL} is cached. Use calculate_macd (12/26/9). "
        "Report: MACD line, signal line, histogram, crossover status, latest "
        "close, date, and a one-paragraph trend interpretation."
    ),
    expected_output=(
        "MACD line, signal line, histogram, crossover, closing price, date, "
        "and a trend interpretation paragraph."
    ),
    agent=macd_agent,
    context=[task_fetch_ohlcv],
)

# ------------------------------------------------------------
# 5.4 Task 4: Write the Trading Report
# ------------------------------------------------------------
task_write_report = Task(
    description=(
        f"Synthesise the RSI and MACD analyses for {SYMBOL} into a structured "
        "trading report with these sections:\n\n"
        "1. EXECUTIVE SUMMARY — symbol, date, recommendation in 2-3 sentences.\n"
        "2. RSI FINDINGS — value, signal, momentum implication.\n"
        "3. MACD FINDINGS — line, signal, histogram, crossover, trend implication.\n"
        "4. COMBINED SIGNAL ANALYSIS — agreement or conflict between indicators.\n"
        "   • Both bullish  → Strong BUY\n"
        "   • Both bearish  → Strong NO BUY\n"
        "   • Mixed signals → Cautious stance with explanation\n"
        "5. RECOMMENDATION — BUY or NO BUY with rationale and risk caveats.\n"
        "6. DISCLAIMER — this is technical analysis only, not financial advice.\n\n"
        "IMPORTANT: The very last line of your output must be EXACTLY one of:\n"
        "   FINAL DECISION: BUY\n"
        "   FINAL DECISION: NO BUY\n"
        "This line is parsed programmatically to trigger order execution."
    ),
    expected_output=(
        "A structured six-section trading report. The absolute last line must "
        "be 'FINAL DECISION: BUY' or 'FINAL DECISION: NO BUY'."
    ),
    agent=strategy_agent,
    context=[task_calculate_rsi, task_calculate_macd],
)

# ------------------------------------------------------------
# 5.5 Task 5: Execute Paper Trade (if BUY)
# ------------------------------------------------------------
task_execute_trade = Task(
    description=(
        "Read the trading report from the Strategy Analyst. "
        "Look for the line 'FINAL DECISION: BUY' or 'FINAL DECISION: NO BUY'.\n\n"
        "IF the decision is BUY:\n"
        f"  • Call place_paper_trade with symbol='{SYMBOL}' and "
        f"notional={TRADE_NOTIONAL}\n"
        "  • Report the full order confirmation (order ID, status, notional, "
        "    filled qty, filled avg price, submitted_at).\n\n"
        "IF the decision is NO BUY:\n"
        "  • Do NOT call place_paper_trade.\n"
        "  • Report: 'No trade placed — strategy recommendation was NO BUY.' "
        "    and summarise the key reasons from the report.\n\n"
        "Finish with a one-line execution summary."
    ),
    expected_output=(
        "Either a full order confirmation from Alpaca paper trading, or a clear "
        "statement that no trade was placed and the reason why."
    ),
    agent=execution_agent,
    context=[task_write_report],
)

# ============================================================
# 6.0 Crew
# ============================================================
trading_crew = Crew(
    agents=[
        data_fetcher_agent,
        rsi_agent,
        macd_agent,
        strategy_agent,
        execution_agent,
    ],
    tasks=[
        task_fetch_ohlcv,
        task_calculate_rsi,
        task_calculate_macd,
        task_write_report,
        task_execute_trade,
    ],
    process=Process.sequential,
    verbose=True,
)

# ============================================================
# 7.0 Entry point
# ============================================================
if __name__ == "__main__":
    print(f"\n{'='*60}")
    print(f"  Trading Analysis & Execution Crew — {SYMBOL}")
    print(f"  Lookback  : {LOOKBACK_DAYS} days  |  Timeframe: {TIMEFRAME}")
    print(f"  Trade size: ${TRADE_NOTIONAL:,.0f} notional market order")
    print(f"  Mode      : Alpaca PAPER trading")
    print(f"{'='*60}\n")

    result = trading_crew.kickoff()

    print(f"\n{'='*60}")
    print("  EXECUTION SUMMARY")
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

