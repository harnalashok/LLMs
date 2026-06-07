"""
# Last amended: 31st May, 2026
# MCP Client: trading_crew.py
#
# Keep this file: 
#       /home/ashok/finance_pjt/servers/technical_indicators_mcp.py

# Ref: https://github.com/tonykipkemboi/crewai-mcp-demo/tree/main
"""



# ============================================================
# 0.0 Imports
# ============================================================
import os
import json
from datetime import datetime, timedelta

import pandas as pd
import requests
from mcp.server.fastmcp import FastMCP

# ============================================================
# 1.0 MCP Server
# ============================================================
mcp = FastMCP("TechnicalIndicators")

# ============================================================
# 2.0 Alpaca Configuration
# Set these as environment variables before running:
#   export ALPACA_API_KEY="your_key_here"
#   export ALPACA_SECRET_KEY="your_secret_here"
# ============================================================
ALPACA_API_KEY    = os.environ.get("ALPACA_API_KEY", "")
ALPACA_SECRET_KEY = os.environ.get("ALPACA_SECRET_KEY", "")
ALPACA_DATA_URL   = "https://data.alpaca.markets/v2"

HEADERS = {
    "APCA-API-KEY-ID":     ALPACA_API_KEY,
    "APCA-API-SECRET-KEY": ALPACA_SECRET_KEY,
}

# ============================================================
# 3.0 In-memory cache
# Stores the last fetched DataFrame so RSI and MACD tools can
# consume it without making a second network call.
#   _cache["symbol"]    : uppercased ticker that was fetched
#   _cache["timeframe"] : timeframe string used
#   _cache["df"]        : pd.DataFrame of OHLCV bars
# ============================================================
_cache: dict = {}

# ============================================================
# 4.0 Tools
# ============================================================

# ------------------------------------------------------------
# 4.1 fetch_ohlcv — Tool 1: Fetch OHLCV data from Alpaca
# ------------------------------------------------------------
@mcp.tool()
def fetch_ohlcv(
    symbol: str,
    lookback_days: int = 180,
    timeframe: str = "1Day",
) -> dict:
    """
    Fetch OHLCV (Open, High, Low, Close, Volume) bars for a stock
    symbol from Alpaca paper trading and cache them for use by the
    calculate_rsi and calculate_macd tools.

    Call this tool FIRST before calling calculate_rsi or calculate_macd.

    Parameters
    ----------
    symbol        : Stock ticker symbol (e.g. "AAPL", "TSLA", "NVDA")
    lookback_days : Calendar days of history to fetch — default 180.
                    Use ≥ 90  for RSI with period=14.
                    Use ≥ 180 for MACD with slow_period=26.
    timeframe     : Bar size — "1Day" (default) | "1Hour" | "15Min" etc.
                    Must be a valid Alpaca timeframe string.

    Returns
    -------
    dict with:
        symbol        : ticker (uppercased)
        timeframe     : bar size used
        start         : first bar timestamp (UTC)
        end           : last bar timestamp  (UTC)
        bars_fetched  : total number of bars returned
        columns       : list of OHLCV column names
        sample        : first 3 bars as list-of-dicts (preview)
        status        : "ok" on success
    """
    symbol = symbol.upper()

    end_dt   = datetime.utcnow()
    start_dt = end_dt - timedelta(days=lookback_days)

    params = {
        "symbols":   symbol,
        "timeframe": timeframe,
        "start":     start_dt.strftime("%Y-%m-%dT%H:%M:%SZ"),
        "end":       end_dt.strftime("%Y-%m-%dT%H:%M:%SZ"),
        "limit":     10_000,
        "feed":      "iex",   # free feed; change to "sip" for a paid plan
    }

    url      = f"{ALPACA_DATA_URL}/stocks/bars"
    response = requests.get(url, headers=HEADERS, params=params, timeout=15)
    response.raise_for_status()

    bars = response.json().get("bars", {}).get(symbol, [])

    if not bars:
        raise ValueError(
            f"No bar data returned for '{symbol}'. "
            "Verify the ticker, your API credentials, and that the market "
            "was open during the requested period."
        )

    # Build DataFrame
    df = pd.DataFrame(bars)
    df["t"] = pd.to_datetime(df["t"])
    df = df.set_index("t").sort_index()
    df = df.rename(columns={"o": "open", "h": "high",
                             "l": "low",  "c": "close", "v": "volume"})
    df = df[["open", "high", "low", "close", "volume"]]

    # Store in cache for the indicator tools
    _cache["symbol"]    = symbol
    _cache["timeframe"] = timeframe
    _cache["df"]        = df

    sample = (
        df.head(3)
          .reset_index()
          .rename(columns={"t": "timestamp"})
          .assign(timestamp=lambda x: x["timestamp"].astype(str))
          .to_dict(orient="records")
    )

    return {
        "symbol":       symbol,
        "timeframe":    timeframe,
        "start":        str(df.index[0]),
        "end":          str(df.index[-1]),
        "bars_fetched": len(df),
        "columns":      list(df.columns),
        "sample":       sample,
        "status":       "ok",
    }


# ------------------------------------------------------------
# 4.2 calculate_rsi — Tool 2: Relative Strength Index
# ------------------------------------------------------------
@mcp.tool()
def calculate_rsi(
    period: int = 14,
) -> dict:
    """
    Calculate the Relative Strength Index (RSI) from OHLCV data
    previously fetched by fetch_ohlcv.

    You MUST call fetch_ohlcv before calling this tool.

    Uses Wilder's smoothed moving average (EWM with α = 1/period),
    which is the standard RSI formulation.

    Parameters
    ----------
    period : RSI rolling window — default 14 (industry standard).
             The fetched data must contain at least (period + 1) bars.

    Returns
    -------
    dict with:
        symbol       : ticker
        period       : window used
        rsi          : latest RSI value (0–100)
        signal       : "Overbought" (≥70) | "Oversold" (≤30) | "Neutral"
        latest_close : most recent closing price
        bars_used    : number of bars in the calculation
        as_of        : timestamp of the latest bar
    """
    if "df" not in _cache:
        raise RuntimeError(
            "No data in cache. Call fetch_ohlcv first to load OHLCV data."
        )

    df     = _cache["df"]
    symbol = _cache["symbol"]

    if len(df) < period + 1:
        raise ValueError(
            f"Only {len(df)} bars available; need at least {period + 1} "
            f"for RSI with period={period}. Re-run fetch_ohlcv with a "
            "larger lookback_days."
        )

    closes = df["close"]
    delta  = closes.diff()

    gain = delta.clip(lower=0)
    loss = (-delta).clip(lower=0)

    avg_gain = gain.ewm(com=period - 1, min_periods=period).mean()
    avg_loss = loss.ewm(com=period - 1, min_periods=period).mean()

    rs  = avg_gain / avg_loss.replace(0, float("inf"))
    rsi = 100 - (100 / (1 + rs))

    latest_rsi   = round(float(rsi.iloc[-1]),    2)
    latest_close = round(float(closes.iloc[-1]), 4)
    as_of        = str(df.index[-1])

    if latest_rsi >= 70:
        signal = "Overbought"
    elif latest_rsi <= 30:
        signal = "Oversold"
    else:
        signal = "Neutral"

    return {
        "symbol":       symbol,
        "period":       period,
        "rsi":          latest_rsi,
        "signal":       signal,
        "latest_close": latest_close,
        "bars_used":    len(df),
        "as_of":        as_of,
    }


# ------------------------------------------------------------
# 4.3 calculate_macd — Tool 3: Moving Average Convergence Divergence
# ------------------------------------------------------------
@mcp.tool()
def calculate_macd(
    fast_period: int = 12,
    slow_period: int = 26,
    signal_period: int = 9,
) -> dict:
    """
    Calculate MACD (Moving Average Convergence Divergence) from OHLCV
    data previously fetched by fetch_ohlcv.

    You MUST call fetch_ohlcv before calling this tool.

    Computes:
        MACD line   = EMA(fast_period) − EMA(slow_period)
        Signal line = EMA(signal_period) of the MACD line
        Histogram   = MACD line − Signal line

    Parameters
    ----------
    fast_period   : Fast EMA window   — default 12
    slow_period   : Slow EMA window   — default 26
    signal_period : Signal line EMA   — default 9
                    The fetched data must contain at least slow_period bars.

    Returns
    -------
    dict with:
        symbol        : ticker
        fast_period   : fast EMA window used
        slow_period   : slow EMA window used
        signal_period : signal EMA window used
        macd_line     : MACD line  (fast EMA − slow EMA)
        signal_line   : signal line (EMA of MACD line)
        histogram     : macd_line − signal_line
        crossover     : "Bullish" | "Bearish" | "None"
        latest_close  : most recent closing price
        bars_used     : number of bars in the calculation
        as_of         : timestamp of the latest bar
    """
    if "df" not in _cache:
        raise RuntimeError(
            "No data in cache. Call fetch_ohlcv first to load OHLCV data."
        )

    df     = _cache["df"]
    symbol = _cache["symbol"]

    if len(df) < slow_period:
        raise ValueError(
            f"Only {len(df)} bars available; need at least {slow_period} "
            f"for MACD with slow_period={slow_period}. Re-run fetch_ohlcv "
            "with a larger lookback_days."
        )

    closes = df["close"]

    ema_fast    = closes.ewm(span=fast_period,   adjust=False).mean()
    ema_slow    = closes.ewm(span=slow_period,   adjust=False).mean()
    macd_line   = ema_fast - ema_slow
    signal_line = macd_line.ewm(span=signal_period, adjust=False).mean()
    histogram   = macd_line - signal_line

    latest_macd   = round(float(macd_line.iloc[-1]),   4)
    latest_signal = round(float(signal_line.iloc[-1]), 4)
    latest_hist   = round(float(histogram.iloc[-1]),   4)
    latest_close  = round(float(closes.iloc[-1]),      4)
    as_of         = str(df.index[-1])

    # Crossover: compare histogram sign on current vs previous bar
    prev_hist = float(histogram.iloc[-2]) if len(histogram) >= 2 else 0.0
    if prev_hist <= 0 and latest_hist > 0:
        crossover = "Bullish"   # MACD crossed above signal line
    elif prev_hist >= 0 and latest_hist < 0:
        crossover = "Bearish"   # MACD crossed below signal line
    else:
        crossover = "None"

    return {
        "symbol":        symbol,
        "fast_period":   fast_period,
        "slow_period":   slow_period,
        "signal_period": signal_period,
        "macd_line":     latest_macd,
        "signal_line":   latest_signal,
        "histogram":     latest_hist,
        "crossover":     crossover,
        "latest_close":  latest_close,
        "bars_used":     len(df),
        "as_of":         as_of,
    }


# ============================================================
# 5.0 Entry point
# ============================================================
if __name__ == "__main__":
    mcp.run(transport="stdio")



"""
Verify MCP server is running:
============================

    # Use uv for package management, launch the inspector via the built-in CLI:
    # Activate the crewai python environment
    #  And execute:

        uv run mcp dev maths_mcp_server.py
    
    # The above may ask to install '@modelcontextprotocol/inspector'
    # Go ahead and install it.
    # A web-site opens (http://localhost:6274/?MCP_PROXY_AUTH_TOKEN=ae6f2261545f53a7d1310979347cee7c3b6fc4ce1b404d878e2943b9ee90cc82#tools)

    Verification Steps:
        1. Open the UI link displayed in your terminal (typically http://localhost:5173).
        2. Click Connect to initialize the handshake and check baseline capability registration.
        3. Navigate to the Tools or Resources tab to view your parsed JSON schemas.
        4. Fill in the arguments form and click Run Tool to inspect error handling and outputs

"""