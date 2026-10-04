"""
# Last amended: 4th Oct, 2026
# MCP Client - CrewAI trading agents (RSI + MACD) for a LIST of stocks
# MCP Server: servers/technical_indicators_mcp_server_multiStocks.py (started via stdio)
#
# Four agents, run sequentially in ONE kickoff:
#   Agent 1 : Task 1     - fetch OHLCV for ALL symbols in one call
#   Agent 2 : N tasks    - RSI, one small task per stock
#   Agent 3 : N tasks    - MACD, one small task per stock
#   Agent 4 : final task - reads every report plus your CURRENT HOLDINGS and
#             decides BUY, SELL or HOLD for each stock
#
# BUY / SELL / HOLD semantics (long-only, no short selling):
#   not held : BUY (open a position)  or  HOLD (stay out / no action)
#   held     : BUY (add to it), SELL (close it)  or  HOLD (keep as is)
# Holdings are read from your Alpaca PAPER account (positions endpoint).
#
# Reports: every agent's output is also written to Markdown in ./run_reports/
#   (created if missing), named  agent<N>-<ddmmyyyy>-<HH:MM>.md , e.g.
#   agent2-04102026-14:25.md   (agent1 fetcher, 2 RSI, 3 MACD, 4 strategy).
#   Agents 2 and 3 append one section per stock to their single file.
#
# Why one task per stock for agents 2 and 3: small local models make
# malformed tool calls (e.g. pasting earlier results in as arguments) when one
# task needs many calls in a row. Short tasks avoid that.
#
# Prerequisites:  uv add crewai crewai-tools mcp pandas requests
#   export ALPACA_API_KEY=...   export ALPACA_SECRET_KEY=...   (never hard-code)
#
# Usage:
#   python trading_crew_multiStocks.py                      # default list below
#   python trading_crew_multiStocks.py AAPL MSFT JPM XOM    # your own list
"""

import os
import sys
import json
import requests
from datetime import datetime
from pathlib import Path
from typing import Literal

from pydantic import BaseModel, Field
from crewai import Agent, Task, Crew, Process, LLM
from crewai_tools import MCPServerAdapter
from mcp import StdioServerParameters

# ============================================================
# 1.0 Configuration
# ============================================================
DEFAULT_SYMBOLS = ["AAPL", "MSFT", "NVDA", "JPM", "XOM"]
SYMBOLS = [s.upper() for s in sys.argv[1:]] or DEFAULT_SYMBOLS

LOOKBACK_DAYS = 180
TIMEFRAME     = "1Day"

# Holdings: read from Alpaca paper account. To test offline set a dict instead:
#   HOLDINGS_OVERRIDE = {"AAPL": {"qty": 10, "avg_entry": 190.0,
#                                 "market_value": 1950.0, "pl_pct": 2.6}}
HOLDINGS_OVERRIDE  = None
ALPACA_TRADING_URL = os.environ.get("ALPACA_TRADING_URL", "https://paper-api.alpaca.markets/v2")
INCLUDE_HELD_SYMBOLS = True   # also analyse held stocks that are not in the watch-list

# Portfolio rules (applied in plain Python after the crew finishes)
CAPITAL          = 100_000
MAX_BUYS         = 5
MAX_SELLS        = None   # None = no limit (sells reduce risk); or e.g. 3 to cap turnover

# MAX_POSITION_PCT is the most you will hold in any single stock: 20% of capital,
#                  or $20,000. It does two things:
#                       a. It caps each new buy, so one stock can't take a large share of the budget.
#                       b. If you already hold the stock, a BUY ("add to position") is limited to the 
#                          room left under the cap. Holding $19,000 of JPM leaves room for only $1,000 more.
#                          If it is already at the cap, the buy is skipped and noted in the plan.
# CASH_RESERVE_PCT = 0.10 (cash buffer)
#                   This is the share of capital that is never spent: 10%, or $10,000. 
#                   It keeps some cash for price moves, later opportunities and fees. 

MAX_POSITION_PCT = 0.20
CASH_RESERVE_PCT = 0.10

# Where is our MCP server file. 
MCP_SERVER_PATH = str(Path(__file__).parent / "servers" / "technical_indicators_mcp_server_multiStocks.py")
# Local LLM. MAke it good for your machine. Ollama is recommended for local use,
# but you can use any LLM that CrewAI supports.
local_llm = LLM(model="ollama/mistral:latest",
                base_url="http://localhost:11434")


# What all you are holding in your Alpaca paper account. 
# If you want to test offline, set HOLDINGS_OVERRIDE above.
def get_holdings() -> dict:
    """{symbol: {qty, avg_entry, market_value, pl_pct}} from Alpaca paper positions."""
    if HOLDINGS_OVERRIDE is not None:
        return {k.upper(): v for k, v in HOLDINGS_OVERRIDE.items()}
    key, secret = os.environ.get("ALPACA_API_KEY", ""), os.environ.get("ALPACA_SECRET_KEY", "")
    if not key or not secret:
        print("WARNING: Alpaca keys not set; assuming NO current holdings.")
        return {}
    try:
        r = requests.get(f"{ALPACA_TRADING_URL}/positions", timeout=15,
                         headers={"APCA-API-KEY-ID": key, "APCA-API-SECRET-KEY": secret})
        r.raise_for_status()
        return {p["symbol"].upper(): {
                    "qty": float(p["qty"]),
                    "avg_entry": float(p["avg_entry_price"]),
                    "market_value": float(p["market_value"]),
                    "pl_pct": float(p["unrealized_plpc"]) * 100}
                for p in r.json() if float(p["qty"]) > 0}
    except Exception as e:
        print(f"WARNING: could not read positions ({e}); assuming NO current holdings.")
        return {}

# Get the current holdings
HOLDINGS = get_holdings()
# Add any held symbols to the list of symbols to analyze
if INCLUDE_HELD_SYMBOLS:
    SYMBOLS += [s for s in HOLDINGS if s not in SYMBOLS]

# Prepare the list of symbols for JSON serialization
symbols_json  = json.dumps(SYMBOLS)
symbols_plain = ", ".join(SYMBOLS)

# Prepare the holdings text for display
held_lines = [f"  - {s}: {h['qty']:g} shares, avg entry ${h['avg_entry']:.2f}, "
              f"market value ${h['market_value']:,.0f}, unrealized P/L {h['pl_pct']:+.1f}%"
              for s, h in HOLDINGS.items() if s in SYMBOLS]
# Identify symbols that are not currently held
not_held = [s for s in SYMBOLS if s not in HOLDINGS]

# Create a summary of current holdings and not held symbols
#  builds a plain-text summary of your portfolio. The program 
#  inserts it into the final agent's task description and prints
#  it at the start of a run. It is how agent 4 learns which stocks
#   you already own, so it can decide between SELL and "stay out".
holdings_text = ("Currently HELD:\n" + ("\n".join(held_lines) if held_lines else "  (none)")
                 + "\nNOT held: " + (", ".join(not_held) if not_held else "(none)"))

# ============================================================
# 2.0 Structured output of the final task
# ============================================================
# Our final task returns a structured report (Pydantic) 
# with an executive summary and a list of decisions.
Lean = Literal["BULLISH", "BEARISH", "NEUTRAL", "MISSING"]

# Define the structure of a single decision for a stock 
class Decision(BaseModel):
    symbol: str
    decision: Literal["BUY", "SELL", "HOLD"]
    conviction: int = Field(ge=1, le=10, description="1 = weak, 10 = strong")
    rsi_lean: Lean = Field(description="Copy the RSI lean; MISSING if the RSI report is an ERROR or absent")
    macd_lean: Lean = Field(description="Copy the MACD lean; MISSING if the MACD report is an ERROR or absent")
    rsi_view: str = Field(description="RSI value, signal and what it implies")
    macd_view: str = Field(description="MACD readings, crossover and what they imply")
    rationale: str = Field(description="Combined reasoning and risk caveats")

# Define the structure of the final report containing all decisions
class FinalReport(BaseModel):
    executive_summary: str = Field(description="2-4 sentences on the whole watch-list")
    decisions: list[Decision]

# ============================================================
# 3.0 MCP server connection
# ============================================================

# Define the parameters for connecting to the MCP server. The server is started
# as a subprocess using the specified command and arguments. The environment
# variables are inherited from the current process, with an additional variable
# to specify the Python version. The working directory is set to the directory
# containing this script.
stdio_params = StdioServerParameters(command="python", args=[MCP_SERVER_PATH],
                                     env={**os.environ})

# MCPServerAdapter connects to the MCP server and makes its 
# tools available to agents.
mcp_adapter = MCPServerAdapter(stdio_params)

# The pick function filters the available tools from the MCP server
# based on the provided names. It returns a list of tools that match
# the specified names.
def pick(*names):
    return [t for t in mcp_adapter.tools if t.name in names]

# ============================================================
# 4.0 Pick the tools we need from the MCP server
# ============================================================  
fetch_tools = pick("fetch_ohlcv_batch")
rsi_tools   = pick("calculate_rsi")
macd_tools  = pick("calculate_macd")
print("Fetch tools:", [t.name for t in fetch_tools])
print("RSI tools  :", [t.name for t in rsi_tools])
print("MACD tools :", [t.name for t in macd_tools])

# ============================================================
# 4.0 Agents (each gets only the tool it needs)
# ============================================================

# Data fetcher agent retrieves historical OHLCV price data for all stocks
# in the watch-list in a single call. It connects to brokerage APIs, 
# validates the returned data, and passes clean summaries to quantitative analysts.      
data_fetcher_agent = Agent(
                            role="Market Data Fetcher",
                            goal=("Fetch historical OHLCV price data for ALL stocks in the watch-list in a "
                                "single call so downstream agents can compute technical indicators."),
                            backstory=("You are a specialist in retrieving financial market data. You connect "
                                    "to brokerage APIs, validate the returned data, and pass clean "
                                    "summaries to quantitative analysts."),
                            tools=fetch_tools,
                            verbose=True,
                            llm=local_llm,
                         )

# RSI and MACD agents each get their own tool and are responsible for computing
# the respective technical indicators for each stock in the watch-list. They are designed
# to handle one stock at a time to avoid issues with malformed tool calls in small local models 
rsi_agent = Agent(
    role="RSI Technical Analyst",
    goal=("Calculate the 14-period RSI for one stock at a time and report the "
          "tool's values and lean exactly."),
    backstory=("You are a quantitative analyst who specialises in momentum indicators. "
               "You compute RSI values and report them faithfully, never inventing "
               "numbers."),
    tools=rsi_tools, verbose=True, llm=local_llm, max_iter=10,
)

# MACD agent is responsible for calculating the MACD indicator for each stock in the watch-list.
macd_agent = Agent(
                    role="MACD Technical Analyst",
                    goal=("Calculate the MACD (12/26/9) for one stock at a time and report the "
                        "tool's values and lean exactly."),
                    backstory=("You are a quantitative analyst who specialises in trend-following "
                            "indicators. You compute MACD values and report them faithfully, "
                            "never inventing numbers."),
                    tools=macd_tools,
                    verbose=True,
                    llm=local_llm,
                    max_iter=10,
                )

# Strategy agent combines the RSI and MACD reports for every stock in the watch-list and gives each
# a clear BUY, SELL or HOLD decision backed by technical reasoning. It is designed to weigh conflicting
# signals, manage risk, and communicate recommendations clearly, without trading on missing evidence.

strategy_agent = Agent(
                        role="Trading Strategy Analyst",
                        goal=("Combine the RSI and MACD reports for every stock in the watch-list and "
                            "give each a clear BUY, SELL or HOLD decision backed by technical reasoning."),
                        backstory=("You are a senior portfolio manager with deep expertise in technical "
                                "analysis. You weigh conflicting signals, manage risk, and communicate "
                                "recommendations clearly. You never trade on missing evidence."),
                        tools=[],
                        verbose=True,
                        llm=local_llm,
                     )

# ============================================================
# 4.5 Markdown report writer (one file per agent, in ./run_reports)
# ============================================================
REPORT_DIR = Path.cwd() / "run_reports"
REPORT_DIR.mkdir(parents=True, exist_ok=True)      # create folder if missing
_report_files: dict = {}                           # agent number -> Path
_MODEL_NAME = "ollama/granite4.1:3b"

# Render the final report as Markdown for easy reading and sharing. It includes 
#  an executive summary and detailed decisions for each stock, formatted with 
#   headings and bullet points for clarity.
def render_final(report) -> str:
    """Markdown rendering of the FinalReport (Pydantic) object."""
    lines = ["### Executive summary", "", report.executive_summary, ""]
    for d in report.decisions:
        lines += [f"### {d.symbol}: {d.decision} (conviction {d.conviction}/10)", "",
                  f"- **RSI lean:** {d.rsi_lean} | **MACD lean:** {d.macd_lean}",
                  f"- **RSI:** {d.rsi_view}",
                  f"- **MACD:** {d.macd_view}",
                  f"- **Rationale:** {d.rationale}", ""]
    return "\n".join(lines)


# Agent's report file is created the first time it writes a report. The filename 
# includes the agent number, role, and timestamp to ensure uniqueness. 
# If a file with the same name already exists (e.g., due to a rerun in the same minute),
# seconds are added to the filename.
def _agent_file(n: int, role: str) -> Path:
    """File for agent n; name is fixed at the time of its first report."""
    if n not in _report_files:
        now  = datetime.now()
        path = REPORT_DIR / f"agent{n}-{now.strftime('%d%m%Y-%H:%M')}.md"
        if path.exists():                          # same-minute rerun: add seconds
            path = REPORT_DIR / f"agent{n}-{now.strftime('%d%m%Y-%H:%M:%S')}.md"
        path.write_text(
            f"# Agent {n}: {role}\n\n"
            f"- Run started: {now.strftime('%d %b %Y, %H:%M:%S')}\n"
            f"- Watch-list: {', '.join(SYMBOLS)}\n"
            f"- Model: {_MODEL_NAME}\n\n---\n\n", encoding="utf-8")
        _report_files[n] = path
    return _report_files[n]

# Append a new section to the agent's report file. Each section includes a title,
# timestamp, and the body of the report. The function ensures that the report is
# written in UTF-8 encoding and appends a horizontal rule for separation between sections.  
def append_report(n: int, role: str, title: str, body: str) -> None:
    path = _agent_file(n, role)
    with path.open("a", encoding="utf-8") as f:
        f.write(f"## {title}\n\n_Written {datetime.now().strftime('%d %b %Y, %H:%M:%S')}_\n\n"
                f"{body.strip()}\n\n---\n\n")


# Make a callback function for each agent's task that appends the task's output to
# the agent's Markdown report file. The callback handles both structured (Pydantic)
# and raw outputs, rendering them appropriately before writing to the report.
# Any exceptions during reporting are caught and logged to avoid breaking the crew's execution.
def make_report_writer(n: int, role: str, title: str):
    """Task callback: appends the task's output to this agent's .md file."""
    def _write(output) -> None:
        try:
            pyd  = getattr(output, "pydantic", None)
            body = render_final(pyd) if isinstance(pyd, FinalReport) else str(output.raw)
            append_report(n, role, title, body)
        except Exception as e:                     # never let reporting break the crew
            print(f"WARNING: could not write report for agent {n} ({title}): {e}")
    return _write


# ============================================================
# 5.0 Tasks
# ============================================================
task_fetch_ohlcv = Task(
                        name="Fetch OHLCV for all symbols",
                        description=(
                                    f"Watch-list: {symbols_plain}\n\n"
                                    "Call the fetch_ohlcv_batch tool EXACTLY ONCE with "
                                    f"symbols={symbols_json}, lookback_days={LOOKBACK_DAYS}, "
                                    f"timeframe='{TIMEFRAME}'. Send no other arguments.\n"
                                    "Then report, for EACH symbol: the date range (start -> end), the number "
                                    "of bars returned, and the last close. List any symbols returned as "
                                    "'missing'. Do not calculate any indicators."
                                    ),
                        expected_output=("A per-symbol confirmation table (symbol, start, end, bars, "
                                        "last close) plus the list of missing symbols, if any."),
                        agent=data_fetcher_agent,
                        callback=make_report_writer(1,
                                                    "Market Data Fetcher", 
                                                    "Fetch OHLCV for all symbols"),
                     )


# Define a function to create tasks for calculating technical indicators (RSI or MACD)
# for each stock symbol.
def make_indicator_tasks(agent, agent_no, role, tool_name, label, fields):
    """One small task per symbol, so each needs exactly one tool call."""
    tasks = []
    for s in SYMBOLS:
        tasks.append(Task(
            name=f"{label} {s}",
            description=(
                f"Call the {tool_name} tool exactly once with ONE argument: "
                f"symbol='{s}'. Pass nothing else (no result fields, no other "
                "arguments).\n"
                "If the tool returns a validation error, call it again with only "
                f"symbol='{s}'.\n"
                f"Report for {s}: {fields}, plus the tool's 'lean' and "
                "'interpretation' copied exactly.\n"
                "If the tool still fails, write 'ERROR:' followed by the error "
                "text, and lean MISSING. Never invent values."
            ),
            expected_output=(f"{label} report for {s}: values, lean "
                             "(BULLISH/BEARISH/NEUTRAL) and interpretation, "
                             "or an ERROR line."),
            agent=agent,
            context=[task_fetch_ohlcv],
            callback=make_report_writer(agent_no, role, f"{label} {s}"),
        ))
    return tasks

# Create tasks for RSI and MACD calculations for each stock symbol. Each task
# is assigned to the respective agent and includes a description of the expected 
# output. The tasks are designed to ensure that each agent calls its tool exactly
# once per symbol, handling any validation errors appropriately.
rsi_tasks = make_indicator_tasks( rsi_agent, 2, "RSI Technical Analyst", "calculate_rsi", "RSI",
                                "RSI value, signal, latest_close, as_of" )
                                
# Create tasks for MACD calculations for each stock symbol. Each task is assigned to the 
# MACD agent and includes a description of the expected output. The tasks are designed
# to ensure that the MACD agent calls its tool exactly once per symbol, handling any 
# validation errors appropriately.
macd_tasks = make_indicator_tasks( macd_agent, 3, "MACD Technical Analyst", "calculate_macd", "MACD",
                                    "macd_line, signal_line, histogram, crossover, latest_close, as_of"  )

# Create the final task for the strategy agent, which combines the RSI and MACD reports
# for each stock symbol and makes a BUY, SELL, or HOLD decision. The task includes
# detailed instructions on how to interpret the indicator reports and how to make decisions
# based on the current holdings and the technical analysis. The output is structured
# as a Pydantic model (FinalReport) to ensure consistency and clarity in the results
task_write_report = Task(
                        name="Final decisions",
                        description=(
                                    f"You have the RSI report and the MACD report for each of: {symbols_plain}.\n\n"
                                    f"{holdings_text}\n\n"
                                    "For EVERY symbol, in the same order, decide BUY, SELL or HOLD. "
                                    "Short selling is NOT allowed.\n"
                                    "If the symbol is NOT held:\n"
                                    "  - Both leans BULLISH (and RSI < 70) -> BUY\n"
                                    "  - Anything else -> HOLD (meaning: stay out, no action). Never SELL.\n"
                                    "If the symbol IS held:\n"
                                    "  - Both leans BEARISH, or RSI >= 70 with a BEARISH MACD -> SELL\n"
                                    "  - Both leans BULLISH (and RSI < 70) -> BUY (add to the position) "
                                    "only if you are strongly convinced, otherwise HOLD\n"
                                    "  - Mixed or neutral signals -> HOLD\n"
                                    "  - Mention the position's unrealized P/L in the rationale\n"
                                    "If either indicator report is an ERROR, missing, or says 'no data': set "
                                    "that lean to MISSING and decide HOLD with conviction 1 (never BUY or "
                                    "SELL on missing evidence).\n"
                                    "Copy rsi_lean and macd_lean from the reports; copy the numbers into "
                                    "rsi_view and macd_view; do not reinterpret RSI levels yourself.\n"
                                    "Conviction (1-10) is how strong the decision is. Add a rationale with "
                                    "risk caveats (volume, fundamentals, earnings, macro), and an "
                                    "executive_summary of 2-4 sentences for the whole watch-list. "
                                    "Technical analysis only; not financial advice."
                                    ),
                        expected_output=("An executive summary plus one decision per symbol "
                                        "(symbol, decision BUY/SELL/HOLD, conviction, rsi_lean, "
                                        "macd_lean, rsi_view, macd_view, rationale)."),
                        agent=strategy_agent,
                        context=[task_fetch_ohlcv, *rsi_tasks, *macd_tasks],
                        output_pydantic=FinalReport,
                        callback=make_report_writer(4, "Trading Strategy Analyst",
                                                    "Final decisions (raw agent output, before guards)"),
                    )

# ============================================================
# 6.0 Crew
# ============================================================
# The Crew runs all four agents sequentially in one kickoff. It ensures that the data 
# fetcher runs first,
trading_crew = Crew(
                    agents=[data_fetcher_agent, rsi_agent, macd_agent, strategy_agent],
                    tasks=[task_fetch_ohlcv, *rsi_tasks, *macd_tasks, task_write_report],
                    process=Process.sequential,
                    verbose=True,
                    llm=local_llm,)


# ============================================================
# 7.0 Portfolio rules (plain Python - deterministic)
# ============================================================
# The following functions implement portfolio rules to ensure that the
# decisions made by the agents are safe and consistent with the current holdings.
# They check for incomplete data, apply guards to prevent invalid trades, 
# and create a final action plan based on the decisions.

def incomplete(d: Decision) -> bool:
    text = (d.rsi_view + " " + d.macd_view).lower()
    return (d.rsi_lean == "MISSING" or d.macd_lean == "MISSING"
            or "no data" in text or "error" in text)

# Apply guards to the decisions made by the agents to ensure they are safe 
# and consistent with the current holdings. If a decision is not HOLD and 
# the data is incomplete, it is forced to HOLD with a conviction of 1. 
# If a decision is SELL but the stock is not held, it is changed to HOLD 
# with an appropriate rationale.

def apply_guards(decisions: dict, holdings: dict) -> None:
    """Make LLM decisions safe and consistent with what is actually held."""
    for s, d in decisions.items():
        if d.decision != "HOLD" and incomplete(d):
            d.decision, d.conviction = "HOLD", 1
            d.rationale += " [Forced HOLD: incomplete indicator data]"
        elif d.decision == "SELL" and s not in holdings:
            d.decision = "HOLD"
            d.rationale += " [SELL changed to HOLD: not held, short selling not allowed]"

# Create a plan based on the decisions and current holdings. The plan includes
# the stocks to sell, the stocks to buy, and any skipped actions due to portfolio
# rules. It calculates the available cash after sells and ensures that the
# maximum position size and cash reserve percentages are respected. The plan is 
# returned as a dictionary containing the sells, buys, skipped actions, and cash 
# after the plan.

def make_plan(decisions: dict, holdings: dict) -> dict:
    """Returns {'sells': {...}, 'buys': {...}, 'skipped': [...]} - no orders are placed."""
    sell_ranked = sorted((d for d in decisions.values()
                          if d.decision == "SELL" and d.symbol in holdings),
                         key=lambda d: d.conviction, reverse=True)
    deferred = []
    if MAX_SELLS is not None and len(sell_ranked) > MAX_SELLS:
        deferred = [f"{d.symbol}: SELL deferred (over MAX_SELLS={MAX_SELLS}; "
                    f"conviction {d.conviction})" for d in sell_ranked[MAX_SELLS:]]
        sell_ranked = sell_ranked[:MAX_SELLS]
    sells = {d.symbol: holdings[d.symbol] for d in sell_ranked}

    # Cash after sells = capital minus value of positions we keep
    kept_value = sum(h["market_value"] for s, h in holdings.items() if s not in sells)
    spendable  = max(0.0, CAPITAL - kept_value - CAPITAL * CASH_RESERVE_PCT)
    cap_dollars = CAPITAL * MAX_POSITION_PCT

    candidates = sorted((d for d in decisions.values() if d.decision == "BUY"),
                        key=lambda d: d.conviction, reverse=True)[:MAX_BUYS]
    buys, skipped = {}, list(deferred)
    if candidates:
        per_stock = min(spendable / len(candidates), cap_dollars)
        for d in candidates:
            existing = holdings.get(d.symbol, {}).get("market_value", 0.0)
            room = cap_dollars - existing
            amount = min(per_stock, room)
            if amount < 1:
                skipped.append(f"{d.symbol}: BUY skipped (position already at the "
                               f"{MAX_POSITION_PCT:.0%} cap or no spendable cash)")
            else:
                buys[d.symbol] = round(amount, 2)
    return {"sells": sells, "buys": buys, "skipped": skipped,
            "cash_after": CAPITAL - kept_value - sum(buys.values())}

# ============================================================
# 8.0 Entry point
# ============================================================
# The main entry point of the script. It prints the initial configuration,
# runs the trading crew,
if __name__ == "__main__":
    print(f"\n{'=' * 60}\n  Trading Analysis Crew: {symbols_plain}")
    print(f"  Lookback: {LOOKBACK_DAYS} days | Timeframe: {TIMEFRAME}")
    print(f"{'=' * 60}\n{holdings_text}\n")
    try:
        result = trading_crew.kickoff()
    finally:
        mcp_adapter.stop()

    report = result.pydantic
    decisions = {}
    if report:
        for d in report.decisions:
            if d.symbol.upper() in SYMBOLS:
                decisions[d.symbol.upper()] = d

    # Fail safe: anything the model skipped or failed to parse is HOLD
    for s in SYMBOLS:
        if s not in decisions:
            decisions[s] = Decision(symbol=s, decision="HOLD", conviction=1,
                                    rsi_lean="MISSING", macd_lean="MISSING",
                                    rsi_view="n/a", macd_view="n/a",
                                    rationale="No valid decision returned (fail-safe).")
    # Apply portfolio rules to ensure that the decisions are safe and 
    # consistent with the current holdings.
    apply_guards(decisions, HOLDINGS)

    # Print the final report and action plan, including the executive summary,
    # decisions for each stock, and the recommended actions based on the portfolio rules.   
    print(f"\n{'=' * 60}\n  FINAL REPORT\n{'=' * 60}")
    print(report.executive_summary if report else "(no summary: structured output failed)")
    for s in SYMBOLS:
        d = decisions[s]
        status = "held" if s in HOLDINGS else "not held"
        print(f"\n{s} ({status}): {d.decision} (conviction {d.conviction}/10)  "
              f"[RSI {d.rsi_lean} | MACD {d.macd_lean}]")
        print(f"  RSI : {d.rsi_view}")
        print(f"  MACD: {d.macd_view}")
        print(f"  Why : {d.rationale}")

    # Create an action plan based on the decisions and current holdings, and print it. 
    # The plan includes the stocks to sell, the stocks to buy, any skipped actions due
    # to portfolio rules, and the available cash after the plan. No actual orders are 
    # placed; this is a simulation of what would be done based on the decisions and portfolio rules.
    plan = make_plan(decisions, HOLDINGS)
    print(f"\n{'=' * 60}\n  ACTION PLAN (capital ${CAPITAL:,.0f}, reserve "
          f"{CASH_RESERVE_PCT:.0%}, cap {MAX_POSITION_PCT:.0%}/stock, "
          f"max {MAX_BUYS} buys, max sells "
          f"{MAX_SELLS if MAX_SELLS is not None else 'unlimited'})  - no orders are placed\n{'=' * 60}")
    for s, h in plan["sells"].items():
        print(f"SELL {s:6s} all {h['qty']:g} shares (~${h['market_value']:,.2f})")
    for s, dollars in plan["buys"].items():
        print(f"BUY  {s:6s} ${dollars:,.2f}")
    for note in plan["skipped"]:
        print(note)
        
    # Print the list of stocks that are recommended to HOLD (no action) and the 
    # available cash after the plan.    
    holds = [s for s, d in decisions.items() if d.decision == "HOLD"]
    print("HOLD (no action): " + (", ".join(holds) if holds else "-"))
    print(f"Cash after plan: ${plan['cash_after']:,.2f}")

    # ---- Append the guarded decisions and the action plan to agent 4's report ----
    md = ["### Decisions after safety guards", ""]
    for s in SYMBOLS:
        d = decisions[s]
        md.append(f"- **{s}** ({'held' if s in HOLDINGS else 'not held'}): "
                  f"**{d.decision}** (conviction {d.conviction}/10) - {d.rationale}")
    # Add the action plan to the Markdown report for agent 4, including the list of stocks 
    # to sell, buy, any skipped actions, and the available cash after the plan. 
    # This provides a clear summary of the recommended actions based on the decisions 
    # and portfolio rules.
    md += ["", f"### Action plan (capital ${CAPITAL:,.0f}; no orders placed)", ""]
    for s, h in plan["sells"].items():
        md.append(f"- SELL {s}: all {h['qty']:g} shares (~${h['market_value']:,.2f})")
    for s, dollars in plan["buys"].items():
        md.append(f"- BUY {s}: ${dollars:,.2f}")
    # Add any skipped actions to the Markdown report for agent 4, providing context
    # for why certain actions were not taken. This helps in understanding the constraints
    # and rules applied to the trading decisions. 
    md += [f"- {note}" for note in plan["skipped"]]
    md.append("- HOLD (no action): " + (", ".join(holds) if holds else "-"))
    md.append(f"- Cash after plan: ${plan['cash_after']:,.2f}")
    append_report(4, "Trading Strategy Analyst",
                  "Post-processed decisions and action plan", "\n".join(md))
    # Print the list of report files generated for each agent, providing a summary of where
    # the detailed reports can be found. This allows for easy access to the individual agent 
    # reports for further analysis or review.    
    print(f"\nReports written to {REPORT_DIR}:")
    for n in sorted(_report_files):
        print(f"  {_report_files[n].name}")
        
#################        