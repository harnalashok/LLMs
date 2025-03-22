# 1.0
# Load any environment variables
from dotenv import load_dotenv
load_dotenv()

# 1.1
import nest_asyncio
nest_asyncio.apply()

from llama_index.core.agent.workflow import AgentWorkflow
from llama_index.core import Settings
from llama_index.llms.ollama import Ollama
from llama_index.embeddings.ollama import OllamaEmbedding
from llama_index.llms.openai_like import OpenAILike


# 2.1
"""
# Quick but output is NOT that good.
Settings.llm = Ollama(
                                     model="llama3.2:latest",
                                     request_timeout=120.0,
                                     temperature = 0.4,
                                     mirostat = 0)

"""

# Takes a lot of time but the output is better
Settings.llm = OpenAILike(
                          temperature=0.7,
                          model= "llama-3.2-3b-instruct:q8_0",   # "gpt-3.5-turbo",  # "gemma-3-27b-it",  #          # Can be any name, not necessarily openai's gpt
                          api_base="http://127.0.0.1:8080/v1",
                          api_key="fake",
                          timeout= 1000.0,
                          is_chat_model = True,
                          is_function_calling_model=True,
                          )

# 2.2
Settings.embed_model = OllamaEmbedding(
                                        model_name="nomic-embed-text",      # Using foundational model may be overkill
                                        base_url="http://localhost:11434",
                                       )


def multiply(a: float, b: float) -> float:
    """Multiply two numbers and returns the product"""
    return a * b

def add(a: float, b: float) -> float:
    """Add two numbers and returns the sum"""
    return a + b

llm = Settings.llm

workflow = AgentWorkflow.from_tools_or_functions(
    [multiply, add],
    llm=llm,
    system_prompt="You are an agent that can perform basic mathematical operations using tools."
)

async def main():
    response = await workflow.run(user_msg="What is 20+(2*4)?")
    print(response)

if __name__ == "__main__":
    import asyncio
    asyncio.run(main())
