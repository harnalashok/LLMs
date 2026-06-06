# My folder: D:\Documents\OneDrive\Documents\crewai\python_based

import os
import yfinance as yf
from crewai import Agent, Task, Crew, Process,LLM
from crewai.tools import tool
from crewai_tools import SerperDevTool
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# 3. Define your local Ollama LLM configuration
# Change 'llama3' to any model you have downloaded locally (e.g., 'mistral', 'phi3', etc.)
# 2. Define your local Ollama LLM configuration
# Change 'llama3' to any model you have downloaded locally (e.g., 'mistral', 'phi3', etc.)
local_llm = LLM(
    model="ollama/granite4.1:8b",        # Prefix with 'ollama/' followed by your model name
    base_url="http://localhost:11434" # Default Ollama local server URL
)


# 1. Define the Custom Yahoo Finance Tool
@tool("Yahoo Finance Stock Scraper")
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



# 2. Initialize Web Search Tool
search_tool = SerperDevTool()

# 3. Define the Agents (Equipped with the new tool)
research_analyst = Agent(
    role="Senior Research Analyst",
    goal="Gather hard financial metrics and the latest news for a specific company",
    backstory="You are an expert financial researcher. You use specialized tools to extract live market metrics and search the web for recent news regarding a target company.",
    # Give the research agent both the live data tool and web search
    tools=[yfinance_tool, search_tool],
    llm = local_llm,
    verbose=True,
)

financial_analyst = Agent(
    role="Financial Analyst",
    goal="Analyze the research and raw financial numbers to write a comprehensive report",
    backstory="You are a seasoned financial analyst. You excel at taking raw metrics (like P/E ratios and prices) and matching them with market news to build clear investment insights.",
    tools=[search_tool],
    llm = local_llm,
    verbose=True,
)

# 4. Define the Tasks
research_task = Task(
    description="Extract live financial metrics using the Yahoo Finance tool for {company_ticker}. Then, search for recent news events or earnings context.",
    expected_output="A structured summary containing the live stock numbers and a bulleted list of recent news.",
    agent=research_analyst,
)

analysis_task = Task(
    description="Using the live metrics and news gathered by the researcher, analyze the financial health and valuation of {company_ticker}.",
    expected_output="A professional financial analysis report with a summary of valuation metrics, pros/cons, and future outlook.",
    agent=financial_analyst,
    output_file="financial_report.md"
)

# 5. Assemble and Run the Crew
financial_crew = Crew(
    agents=[research_analyst, financial_analyst],
    tasks=[research_task, analysis_task],
    process=Process.sequential,
    verbose=True
)

if __name__ == "__main__":
    inputs = {'company_ticker': 'NVDA'}
    
    print("## Starting Financial Analysis with Live Data...")
    result = financial_crew.kickoff(inputs=inputs)
    print("\n\n######################")
    print("## Analysis Complete")
    print("######################\n")
    print(result)

"""
AA. How to test your tool:
    1. Create a blank python file.
    2. Import the yfinance library
    3. Copy the yfinance_tool(sticker) function.  
    4. Execute yfinance("NVDA"). It should work.
BB. How to add tools:
    1. Define tool function, at the top of crew.py file
    2. In crew.py, under respective agent write:
        tools=[yfinance_tool, search_tool],
       as for example,

       @agent
        def researcher(self) -> Agent:
            return Agent(
                config=self.agents_config['researcher'], # type: ignore[index]
                verbose=True,
                tools=[yfinance_tool, search_tool],   # both tools
            )
    3. No need to write tools in YAML files   
    4. If required, specify inputs right in the kickoff() (in main.py file), as:

            FinanceAnalyst().crew().kickoff(inputs={"company_ticker" : "NVDA"})      
    5. Done...

"""