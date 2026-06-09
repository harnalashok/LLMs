"""
# Last amended: 20th May, 2026
# My folder: D:\Documents\OneDrive\Documents\crewai\python_based
# 

"""
# 1.0 Call libraries
import os
import json
from crewai import Agent, Task, Crew, Process, LLM
from typing import Type
from pydantic import BaseModel, Field
from crewai.tools import tool
from newsapi import NewsApiClient
from newsapi import NewsApiClient


# 2. Just use the decorator with the tool's name. No args_schema argument.
@tool("News API Extractor")
def extract_news_tool(query: str, limit: int = 5) -> str:
    """
    Searches and extracts recent global news articles on a specific topic 
    using the NewsAPI platform.

    Args:
        query (str): The topic or keyword to search for in the news articles (e.g., 'artificial intelligence').
        limit (int): The maximum number of news articles to return. Defaults to 5.
    """
    #api_key = os.getenv("NEWSAPI_API_KEY")
    api_key = "5feb554bf4d445a4ae84f51ed9763f7d"
    
    if not api_key:
        return "Error: NEWSAPI_API_KEY environment variable is not set."
    
    try:
        newsapi = NewsApiClient(api_key=api_key)
        response = newsapi.get_everything(
            q=query,
            language='en',
            sort_by='publishedAt',
            page_size=limit
        )
        
        articles = response.get("articles", [])
        if not articles:
            return f"No news articles found for the topic: '{query}'."
        
        formatted_results = []
        for i, article in enumerate(articles, start=1):
            source_name = article.get("source", {}).get("name", "Unknown Source")
            title = article.get("title")
            description = article.get("description")
            url = article.get("url")
            
            item_str = f"{i}. **{title}**\n   - **Source:** {source_name}\n   - **Description:** {description}\n   - **URL:** {url}\n"
            formatted_results.append(item_str)
            
        return "\n".join(formatted_results)
        
    except Exception as e:
        return f"An error occurred while fetching news: {str(e)}"



# 3.0
local_llm = LLM(
                model="ollama/qwen2.5:1.5b",        # Prefix with 'ollama/' followed by your model name
                base_url="http://localhost:11434"    # Default Ollama local server URL
                )


# 4.0 Set your API environment variables
os.environ["NEWSAPI_API_KEY"] = "5feb554bf4d445a4ae84f51ed9763f7d"

# 5.0 Define a Research Agent equipped with the new tool
news_researcher = Agent(
                        role='Senior News Researcher',
                        goal='Uncover the absolute latest developments and events regarding requested topics.',
                        backstory='An elite investigative journalist with a knack for sorting through massive streams of news to find key facts.',
                        verbose=True,
                        memory=True,
                        llm = local_llm,
                        tools=[extract_news_tool]  # <--- Custom tool added here
                        )

# 6.0 Define a task for the agent
research_task = Task(
                    description='Extract the 5 most recent articles regarding "Generative AI in healthcare". Provide a clean summary.',
                    expected_output='A summary report of the top news articles including sources and links.',
                    agent=news_researcher
                    )

# 7.0 Run the crew
crew = Crew(
            agents=[news_researcher],
            tasks=[research_task],
            process=Process.sequential
            )

# 8,0
result = crew.kickoff()
print(result)
