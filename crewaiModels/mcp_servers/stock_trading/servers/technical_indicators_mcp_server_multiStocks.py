"""
# Last amended: 4th Oct, 2026
# MCP Server  (stdio transport - started automatically by the client)
# Keep this file in the 'servers' folder below the client program.
# MCP Client: trading_crew.py
#
# Tools
# -----
#   fetch_ohlcv_batch(symbols)  : ONE Alpaca request for ALL symbols; caches each
#   fetch_ohlcv(symbol)         : single-symbol fetch (not used by default)
#   calculate_rsi(symbol)       : RSI for one symbol from the cache
#   calculate_macd(symbol)      : MACD for one symbol from the cache
#
# Indicator tools also return a rule-based `lean` (BULLISH/BEARISH/NEUTRAL) and
# a ready-made `interpretation`, so a small LLM can copy them instead of
# inventing its own reading.
#
# Cache is keyed by symbol. Credentials come from environment variables only.
"""

import os
from datetime import datetime, timedelta, timezone

import pandas as pd
import requests
from mcp.server.fastmcp import FastMCP

mcp = FastMCP("TechnicalIndicators")

ALPACA_API_KEY    = os.environ.get("ALPACA_API_KEY", "")
ALPACA_SECRET_KEY = os.environ.get("ALPACA_SECRET_KEY", "")
ALPACA_DATA_URL   = "https://data.alpaca.markets/v2"
FEED              = "iex"          # free feed; use "sip" on a paid plan

HEADERS = {
    "APCA-API-KEY-ID":     ALPACA_API_KEY,
    "APCA-API-SECRET-KEY": ALPACA_SECRET_KEY,
}

# { "AAPL": {"timeframe": "1Day", "df": DataFrame}, ... }
_cache: dict = {}


# ============================================================
# Helpers
# ============================================================

# Clean and normalize symbols to uppercase, removing duplicates
# and empty entries.
def _clean_symbols(symbols) -> list[str]:
    if isinstance(symbols, str):
        symbols = symbols.replace(",", " ").split()
    out = []
    for s in symbols:
        s = str(s).strip().upper()
        if s and s not in out:
            out.append(s)
    return out


# Fetch OHLCV bars for many symbols in one Alpaca request, returning a dict of DataFrames.
def _fetch_bars(symbols: list[str], lookback_days: int, timeframe: str) -> dict:
    """One (paginated) Alpaca request for many symbols -> {symbol: DataFrame}."""
    end_dt   = datetime.now(timezone.utc)
    start_dt = end_dt - timedelta(days=lookback_days)

    params = {
        "symbols":   ",".join(symbols),
        "timeframe": timeframe,
        "start":     start_dt.strftime("%Y-%m-%dT%H:%M:%SZ"),
        "end":       end_dt.strftime("%Y-%m-%dT%H:%M:%SZ"),
        "limit":     10_000,
        "feed":      FEED,
    }
    url = f"{ALPACA_DATA_URL}/stocks/bars"

    rows: dict[str, list] = {}
    while True:
        resp = requests.get(url, headers=HEADERS, params=params, timeout=20)
        resp.raise_for_status()
        payload = resp.json()
        for sym, bars in (payload.get("bars") or {}).items():
            rows.setdefault(sym, []).extend(bars)
        token = payload.get("next_page_token")
        if not token:
            break
        params["page_token"] = token

    frames = {}
    for sym, bars in rows.items():
        df = pd.DataFrame(bars)
        df["t"] = pd.to_datetime(df["t"])
        df = (df.set_index("t").sort_index()
                .rename(columns={"o": "open", "h": "high", "l": "low",
                                 "c": "close", "v": "volume"})
                [["open", "high", "low", "close", "volume"]])
        frames[sym] = df
    return frames


# Get the DataFrame for a symbol, fetching it if not already cached.
def _get_df(symbol: str):
    """Return cached data for symbol; fetch it only if it is not cached."""
    symbol = symbol.upper()
    if symbol not in _cache:
        frames = _fetch_bars([symbol], 180, "1Day")
        if symbol not in frames:
            raise ValueError(f"No bar data for '{symbol}'. Run fetch_ohlcv_batch "
                             "first and check the ticker.")
        _cache[symbol] = {"timeframe": "1Day", "df": frames[symbol]}
    return _cache[symbol]["df"]


# Generate a summary of the DataFrame for a symbol.
def _summary(symbol: str, df: pd.DataFrame, timeframe: str) -> dict:
    return {"symbol": symbol, "timeframe": timeframe,
            "start": str(df.index[0]), "end": str(df.index[-1]),
            "bars_fetched": len(df),
            "last_close": round(float(df["close"].iloc[-1]), 4)}

#  ===========================================================
# Technical indicator calculations
#  ===========================================================
# RSI and MACD calculations are based on standard formulas, 
# with rule-based interpretations for lean and signal.
def _rsi_value(closes: pd.Series, period: int) -> float:
    delta    = closes.diff()
    avg_gain = delta.clip(lower=0).ewm(com=period - 1, min_periods=period).mean()
    avg_loss = (-delta).clip(lower=0).ewm(com=period - 1, min_periods=period).mean()
    g, l = float(avg_gain.iloc[-1]), float(avg_loss.iloc[-1])
    if l == 0:
        return 100.0 if g > 0 else 50.0
    return round(100 - 100 / (1 + g / l), 2)

# Define the rule-based interpretations for RSI and MACD readings, 
# providing a signal, lean, and interpretation based on the calculated values.
def _rsi_reading(v: float) -> tuple[str, str, str]:
    """(signal, lean, interpretation) from fixed rules."""
    if v >= 70:
        return ("Overbought", "BEARISH",
                "Overbought: stretched to the upside, pullback risk is high.")
    if v <= 30:
        return ("Oversold", "NEUTRAL",
                "Oversold: a rebound is possible but needs trend confirmation.")
    if v >= 50:
        return ("Neutral", "BULLISH",
                "Above 50: momentum leans positive, not yet overbought.")
    return ("Neutral", "NEUTRAL",
            "Below 50: momentum is soft with no clear upward bias.")

# Define the MACD calculation, including the MACD line, signal line, histogram,
# and crossover detection.
def _macd_values(closes, fast, slow, sig) -> dict:
    macd_line   = (closes.ewm(span=fast, adjust=False).mean()
                   - closes.ewm(span=slow, adjust=False).mean())
    signal_line = macd_line.ewm(span=sig, adjust=False).mean()
    hist        = macd_line - signal_line
    h    = float(hist.iloc[-1])
    prev = float(hist.iloc[-2]) if len(hist) > 1 else 0.0
    if prev <= 0 < h:
        crossover = "Bullish"
    elif prev >= 0 > h:
        crossover = "Bearish"
    else:
        crossover = "None"
    return {"macd_line": round(float(macd_line.iloc[-1]), 4),
            "signal_line": round(float(signal_line.iloc[-1]), 4),
            "histogram": round(h, 4), "crossover": crossover}


# Define the rule-based interpretations for MACD readings, providing
# a lean and interpretation based on the calculated MACD values and 
# crossover detection.
def _macd_reading(m: dict) -> tuple[str, str]:
    """(lean, interpretation) from fixed rules."""
    h, c = m["histogram"], m["crossover"]
    if c == "Bullish":
        return "BULLISH", "Fresh bullish crossover: MACD moved above its signal line."
    if c == "Bearish":
        return "BEARISH", "Fresh bearish crossover: MACD moved below its signal line."
    if h > 0:
        return "BULLISH", "MACD above signal line: upward trend momentum persists."
    if h < 0:
        return "BEARISH", "MACD below signal line: downward trend momentum persists."
    return "NEUTRAL", "MACD and signal line are level: no clear trend."


# ============================================================
# Tools
# ============================================================
@mcp.tool()
def fetch_ohlcv_batch(symbols: list[str], lookback_days: int = 180,
                      timeframe: str = "1Day") -> dict:
    """
    Fetch OHLCV bars for ALL given symbols in ONE Alpaca request and cache
    each symbol's data for calculate_rsi and calculate_macd.
    Call this ONCE with the full list, before any indicator tool.

    Arguments: symbols (list of strings, required), lookback_days (int,
    default 180), timeframe (string, default "1Day"). Send nothing else.

    Returns dict:
        fetched : one entry per symbol (symbol, start, end, bars_fetched,
                  last_close)
        missing : symbols for which no data came back
        status  : "ok"
    """
    syms   = _clean_symbols(symbols)
    frames = _fetch_bars(syms, lookback_days, timeframe)

    fetched, missing = [], []
    for s in syms:
        df = frames.get(s)
        if df is None or df.empty:
            missing.append(s)
            continue
        _cache[s] = {"timeframe": timeframe, "df": df}
        fetched.append(_summary(s, df, timeframe))
    return {"fetched": fetched, "missing": missing, "status": "ok"}


@mcp.tool()
def fetch_ohlcv(symbol: str, lookback_days: int = 180, timeframe: str = "1Day") -> dict:
    """
    Fetch OHLCV bars for ONE symbol and cache them.
    Arguments: symbol (string, required), lookback_days (int), timeframe (string).
    Send nothing else.
    """
    symbol = symbol.upper()
    frames = _fetch_bars([symbol], lookback_days, timeframe)
    if symbol not in frames:
        raise ValueError(f"No bar data returned for '{symbol}'.")
    _cache[symbol] = {"timeframe": timeframe, "df": frames[symbol]}
    return _summary(symbol, frames[symbol], timeframe)


@mcp.tool()
def calculate_rsi(symbol: str, period: int = 14) -> dict:
    """
    RSI (Wilder smoothing) for ONE symbol, from data already fetched by
    fetch_ohlcv_batch.

    Arguments: ONLY symbol (string, required) and optionally period (int,
    default 14). Do NOT pass any result fields such as rsi, signal,
    latest_close, bars_used or as_of.

    Returns dict: symbol, period, rsi, signal, lean (BULLISH|BEARISH|NEUTRAL),
    interpretation, latest_close, bars_used, as_of
    """
    symbol = symbol.upper()
    df = _get_df(symbol)
    if len(df) < period + 1:
        raise ValueError(f"{symbol}: only {len(df)} bars; need {period + 1}.")

    value = _rsi_value(df["close"], period)
    signal, lean, interp = _rsi_reading(value)
    return {"symbol": symbol, "period": period, "rsi": value, "signal": signal,
            "lean": lean, "interpretation": interp,
            "latest_close": round(float(df["close"].iloc[-1]), 4),
            "bars_used": len(df), "as_of": str(df.index[-1])}


@mcp.tool()
def calculate_macd(symbol: str, fast_period: int = 12, slow_period: int = 26,
                   signal_period: int = 9) -> dict:
    """
    MACD for ONE symbol, from data already fetched by fetch_ohlcv_batch.

    Arguments: ONLY symbol (string, required) and optionally fast_period,
    slow_period, signal_period (ints; defaults 12/26/9). Do NOT pass any
    result fields such as macd_line, histogram, crossover or as_of.

    Returns dict: symbol, macd_line, signal_line, histogram, crossover,
    lean (BULLISH|BEARISH|NEUTRAL), interpretation, latest_close, bars_used,
    as_of
    """
    symbol = symbol.upper()
    df = _get_df(symbol)
    if len(df) < slow_period:
        raise ValueError(f"{symbol}: only {len(df)} bars; need {slow_period}.")

    m = _macd_values(df["close"], fast_period, slow_period, signal_period)
    lean, interp = _macd_reading(m)
    return {"symbol": symbol,
            "fast_period": fast_period, "slow_period": slow_period,
            "signal_period": signal_period, **m,
            "lean": lean, "interpretation": interp,
            "latest_close": round(float(df["close"].iloc[-1]), 4),
            "bars_used": len(df), "as_of": str(df.index[-1])}


if __name__ == "__main__":
    mcp.run(transport="stdio")