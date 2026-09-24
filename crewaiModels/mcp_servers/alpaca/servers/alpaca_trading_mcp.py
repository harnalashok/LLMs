# Last amended: 24th Sep, 2026
# MCP server: Alpaca PAPER trading (buy / sell / positions / account)
#
# Requires: pip install fastmcp alpaca-py
# Env vars expected: ALPACA_API_KEY, ALPACA_SECRET_KEY  (your PAPER-trading keys
# from https://app.alpaca.markets/paper/dashboard/overview, not live keys)

import os
from fastmcp import FastMCP
from alpaca.trading.client import TradingClient
from alpaca.trading.requests import MarketOrderRequest
from alpaca.trading.enums import OrderSide, TimeInForce

mcp = FastMCP("alpaca-paper-trading")

ALPACA_API_KEY = os.environ.get("ALPACA_API_KEY", "")
ALPACA_SECRET_KEY = os.environ.get("ALPACA_SECRET_KEY", "")

# paper=True pins this to Alpaca's paper-trading endpoint (fake money, real order flow)
_trading_client = TradingClient(ALPACA_API_KEY, ALPACA_SECRET_KEY, paper=True)


def _order_to_dict(order) -> dict:
    return {
        "order_id": str(order.id),
        "symbol": order.symbol,
        "qty": str(order.qty),
        "side": str(order.side),
        "status": str(order.status),
        "submitted_at": str(order.submitted_at),
    }


@mcp.tool()
def buy_stock(symbol: str, qty: float) -> dict:
    """Place a PAPER-trading market BUY order on Alpaca.

    Args:
        symbol: Ticker symbol, e.g. "TSLA".
        qty: Number of shares to buy (fractional shares allowed).
    """
    order_request = MarketOrderRequest(
        symbol=symbol.upper(),
        qty=qty,
        side=OrderSide.BUY,
        time_in_force=TimeInForce.DAY,
    )
    order = _trading_client.submit_order(order_request)
    return _order_to_dict(order)


@mcp.tool()
def sell_stock(symbol: str, qty: float) -> dict:
    """Place a PAPER-trading market SELL order on Alpaca.

    Args:
        symbol: Ticker symbol, e.g. "TSLA".
        qty: Number of shares to sell (fractional shares allowed).
    """
    order_request = MarketOrderRequest(
        symbol=symbol.upper(),
        qty=qty,
        side=OrderSide.SELL,
        time_in_force=TimeInForce.DAY,
    )
    order = _trading_client.submit_order(order_request)
    return _order_to_dict(order)


@mcp.tool()
def get_position(symbol: str) -> dict:
    """Get the current open position size for a symbol, if any.

    Args:
        symbol: Ticker symbol, e.g. "TSLA".
    """
    try:
        pos = _trading_client.get_open_position(symbol.upper())
        return {
            "symbol": pos.symbol,
            "qty": str(pos.qty),
            "market_value": str(pos.market_value),
            "unrealized_pl": str(pos.unrealized_pl),
        }
    except Exception:
        return {"symbol": symbol.upper(), "qty": "0", "note": "No open position for this symbol."}


@mcp.tool()
def get_open_orders(symbol: str = "") -> dict:
    """List currently open (unfilled) orders, optionally filtered by symbol.

    Args:
        symbol: Ticker symbol to filter by, e.g. "TSLA". Leave empty for all symbols.
    """
    orders = _trading_client.get_orders()
    if symbol:
        orders = [o for o in orders if o.symbol.upper() == symbol.upper()]
    return {
        "count": len(orders),
        "orders": [
            {
                "order_id": str(o.id),
                "symbol": o.symbol,
                "qty": str(o.qty),
                "side": str(o.side),
                "status": str(o.status),
                "submitted_at": str(o.submitted_at),
            }
            for o in orders
        ],
    }


@mcp.tool()
def cancel_all_orders(symbol: str = "") -> dict:
    """Cancel all open orders, optionally restricted to one symbol.

    Args:
        symbol: Ticker symbol to restrict cancellation to, e.g. "TSLA".
                Leave empty to cancel ALL open orders across all symbols.
    """
    if symbol:
        orders = _trading_client.get_orders()
        matching = [o for o in orders if o.symbol.upper() == symbol.upper()]
        for o in matching:
            _trading_client.cancel_order_by_id(o.id)
        return {"cancelled_count": len(matching), "symbol": symbol.upper()}
    else:
        _trading_client.cancel_orders()
        return {"cancelled": "all open orders"}


@mcp.tool()
def get_account_info() -> dict:
    """Get current paper-trading account cash, buying power and portfolio value."""
    acct = _trading_client.get_account()
    return {
        "cash": str(acct.cash),
        "buying_power": str(acct.buying_power),
        "portfolio_value": str(acct.portfolio_value),
    }


if __name__ == "__main__":
    mcp.run()