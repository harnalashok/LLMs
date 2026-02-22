## Simple LLM Chain
## Ref: 1. https://docs.langchain.com/oss/python/integrations/chat/ollama
# #     2. https://reference.langchain.com/python/langchain-ollama/chat_models/ChatOllama

# 1.0 Call libraries
from langchain_ollama import ChatOllama
from langchain_core.prompts import ChatPromptTemplate

# 1.1 Initialize the ChatOllama model, specifying the model name you pulled (e.g., 'mistral')
#     If using a custom base_url, you can specify it here as well
llm = ChatOllama(model="smollm2:360m",
                 base_url="http:..192.240.1.113:11434",
                 temperature=0.0)

# 1.2 Define a prompt template (optional, but good practice in LangChain)
prompt = ChatPromptTemplate.from_messages([
    ("system", "You are a helpful assistant. Answer all questions to the best of your ability."),
    ("human", "{question}")
])

# 1.3 Create a simple chain using LangChain Expression Language (LCEL)
chain = prompt | llm

# 1.4 Invoke the chain
response = chain.invoke({"question": "Tell me a joke on a horse"})

# 1.5 Print the response content
print(response.content)
