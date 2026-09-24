# Last amended: 24th Sep, 2026
# MCP client: place a PAPER-trading SELL order via alpaca_trading_mcp.py
#
# Usage:
#   python sell_order_client.py TSLA 2
#
# Requires: uv add fastmcp
# Edit SERVER_SCRIPT below if alpaca_trading_mcp.py lives in a different folder.

import asyncio
import sys
import os
from fastmcp import Client
from fastmcp.client.transports import PythonStdioTransport

## SERVER_SCRIPT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "alpaca_trading_mcp.py")
SERVER_SCRIPT = "/home/ashok/crewai_pjt/mcp_servers/alpaca/servers/alpaca_trading_mcp.py"
# Explicitly pass the full parent environment through to the server subprocess.
# fastmcp/mcp's default stdio transport only forwards a restricted "safe" set of
# env vars (PATH, HOME, etc.) unless told otherwise, so ALPACA_API_KEY /
# ALPACA_SECRET_KEY would otherwise never reach the server process.
transport = PythonStdioTransport(SERVER_SCRIPT, env=os.environ.copy())


async def place_sell_order(symbol: str, qty: float) -> None:
    async with Client(transport) as client:
        # Show current position before selling, for a sanity check
        position = await client.call_tool("get_position", {"symbol": symbol})
        print("Current position:", position.data)

        # Check for open (unfilled) orders on this symbol first — an existing
        # opposite-side open order (e.g. an unfilled BUY) will make Alpaca
        # reject the SELL as a potential wash trade.
        open_orders = await client.call_tool("get_open_orders", {"symbol": symbol})
        print("Open orders for", symbol, ":", open_orders.data)

        if open_orders.data.get("count", 0) > 0:
            print(f"\nWarning: {open_orders.data['count']} open order(s) exist for {symbol}.")
            print("Selling now may be rejected as a potential wash trade.")
            cancel = input("Cancel these open orders first? [y/N]: ").strip().lower()
            if cancel == "y":
                cancel_result = await client.call_tool("cancel_all_orders", {"symbol": symbol})
                print("Cancelled:", cancel_result.data)

        confirm = input(f"Confirm SELL {qty} share(s) of {symbol}? [y/N]: ").strip().lower()
        if confirm != "y":
            print("Order cancelled.")
            return

        result = await client.call_tool("sell_stock", {"symbol": symbol, "qty": qty})
        print("Order result:", result.data)


if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python sell_order_client.py <SYMBOL> <QTY>")
        sys.exit(1)

    symbol_arg = sys.argv[1].upper()
    qty_arg = float(sys.argv[2])

    asyncio.run(place_sell_order(symbol_arg, qty_arg))