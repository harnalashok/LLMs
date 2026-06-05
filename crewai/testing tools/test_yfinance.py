"""
# Last amended: 20th May, 2026
# How to test a crewai tool
#   Take out the function, put it
#   in a separate file and test its output
#   You can then, maybe, create a single
#   agent/task to test the tool.


"""

import yfinance as yf


def yfinance_tool(ticker: str) -> str:
    """
    Fetches real-time financial metrics for a specific stock ticker.
    Input should be a stock ticker symbol (e.g., 'AAPL', 'NVDA').
    """
    try:
        stock = yf.Ticker(ticker)
        info = stock.info
        
        # Extract key metrics safely
        current_price = info.get('currentPrice', 'N/A')
        fifty_two_week_high = info.get('fiftyTwoWeekHigh', 'N/A')
        fifty_two_week_low = info.get('fiftyTwoWeekLow', 'N/A')
        pe_ratio = info.get('trailingPE', 'N/A')
        market_cap = info.get('marketCap', 'N/A')
        forward_pe = info.get('forwardPE', 'N/A')
        
        # Format the output data for the agent
        data_summary = (
            f"Financial Data for {ticker.upper()}:\n"
            f"- Current Price: ${current_price}\n"
            f"- 52-Week High: ${fifty_two_week_high}\n"
            f"- 52-Week Low: ${fifty_two_week_low}\n"
            f"- Trailing P/E Ratio: {pe_ratio}\n"
            f"- Forward P/E Ratio: {forward_pe}\n"
            #f"- Market Capitalization: ${market_cap:, if isinstance(market_cap, (int, float)) else market_cap}\n"
        )
        return data_summary
    except Exception as e:
        return f"Error fetching data for {ticker}: {str(e)}"
    

print(yfinance_tool("NVDA"))
