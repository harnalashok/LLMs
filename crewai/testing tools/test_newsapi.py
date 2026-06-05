# Free News site
# Ref: https://newsapi.org/
# uv pip install newsapi-python

from newsapi import NewsApiClient

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


print(extract_news_tool("News on Iran-US war", 2) )