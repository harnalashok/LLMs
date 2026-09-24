# Last amended: 24th Sep, 2026
# MCP client: place a PAPER-trading BUY order via alpaca_trading_mcp.py
#
# Usage:
#   python buy_order_client.py TSLA 2
#
# Requires: uv add fastmcp
# Edit SERVER_SCRIPT below if alpaca_trading_mcp.py lives in a different folder.

import asyncio
import sys
import os
from fastmcp import Client
from fastmcp.client.transports import PythonStdioTransport

# SERVER_SCRIPT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "alpaca_trading_mcp.py")
SERVER_SCRIPT = "/home/ashok/crewai_pjt/mcp_servers/alpaca/servers/alpaca_trading_mcpServer.py"

# Explicitly pass the full parent environment through to the server subprocess.
# fastmcp/mcp's default stdio transport only forwards a restricted "safe" set of
# env vars (PATH, HOME, etc.) unless told otherwise, so ALPACA_API_KEY /
# ALPACA_SECRET_KEY would otherwise never reach the server process.
transport = PythonStdioTransport(SERVER_SCRIPT, env=os.environ.copy())


async def place_buy_order(symbol: str, qty: float) -> None:
    async with Client(transport) as client:
        # Show account state before the order, for a sanity check
        account = await client.call_tool("get_account_info", {})
        print("Account before order:", account.data)

        confirm = input(f"Confirm BUY {qty} share(s) of {symbol}? [y/N]: ").strip().lower()
        if confirm != "y":
            print("Order cancelled.")
            return

        result = await client.call_tool("buy_stock", {"symbol": symbol, "qty": qty})
        print("Order result:", result.data)


if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python buy_order_client.py <SYMBOL> <QTY>")
        sys.exit(1)

    symbol_arg = sys.argv[1].upper()
    qty_arg = float(sys.argv[2])

    asyncio.run(place_buy_order(symbol_arg, qty_arg))