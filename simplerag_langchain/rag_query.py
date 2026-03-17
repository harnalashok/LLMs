"""
rag_query.py
------------
Given a user query, retrieves the top-k most relevant chunks from the
PostgreSQL vector store and asks llama3.2 (via Ollama) to answer
strictly from that context.

Prints both the retrieved CONTEXT and the final ANSWER.
"""

import sys
from langchain_ollama import OllamaEmbeddings, OllamaLLM
from langchain_community.vectorstores import PGVector
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser
from langchain_core.runnables import RunnablePassthrough

# ──────────────────────────────────────────────────────────────────────────────
# Configuration
# ──────────────────────────────────────────────────────────────────────────────
OLLAMA_BASE_URL = "http://192.240.1.27:11434"
EMBEDDING_MODEL = "nomic-embed-text"
LLM_MODEL = "llama3.2"

PG_CONNECTION_STRING = "postgresql+psycopg2://gautam:gautam@localhost:5432/gautam"
COLLECTION_NAME = "rag_documents"

TOP_K = 4   # number of chunks to retrieve


# ──────────────────────────────────────────────────────────────────────────────
# Prompt — strictly ground the answer in the provided context
# ──────────────────────────────────────────────────────────────────────────────
RAG_PROMPT_TEMPLATE = """You are a helpful assistant. Answer the user's question using ONLY the information provided in the CONTEXT below.
Do NOT use any knowledge from your pre-training or from outside the provided context.
If the answer cannot be found in the context, respond with exactly: "I don't know based on the provided documents."

CONTEXT:
{context}

QUESTION:
{question}

ANSWER:"""


def get_vectorstore():
    """Connect to the existing PGVector collection."""
    embeddings = OllamaEmbeddings(
                                    model=EMBEDDING_MODEL,
                                    base_url=OLLAMA_BASE_URL,
                                 )
    vectorstore = PGVector(
                            embedding_function=embeddings,
                            collection_name=COLLECTION_NAME,
                            connection_string=PG_CONNECTION_STRING,
                          )
    return vectorstore


def format_context(docs) -> str:
    """Concatenate retrieved document chunks into a single context string."""
    return "\n\n---\n\n".join(
        f"[Source: {doc.metadata.get('source', 'unknown')}]\n{doc.page_content}"
        for doc in docs
    )


def run_query(question: str):
    """
    Retrieve relevant context from the vector store and generate an answer
    using the LLM that is strictly grounded in the retrieved context.
    """
    # 1. Set up vector store and retriever
    vectorstore = get_vectorstore()
    retriever = vectorstore.as_retriever(search_kwargs={"k": TOP_K})

    # 2. Retrieve documents
    retrieved_docs = retriever.invoke(question)

    # ── Print the retrieved context ──────────────────────────────────────────
    print("\n" + "=" * 70)
    print("RETRIEVED CONTEXT")
    print("=" * 70)
    if retrieved_docs:
        for i, doc in enumerate(retrieved_docs, start=1):
            source = doc.metadata.get("source", "unknown")
            print(f"\n[Chunk {i}] Source: {source}")
            print("-" * 50)
            print(doc.page_content)
    else:
        print("(No relevant chunks found in the vector store.)")
    print("=" * 70)

    # 3. Build the LLM and prompt chain
    llm = OllamaLLM(
        model=LLM_MODEL,
        base_url=OLLAMA_BASE_URL,
        temperature=0,   # deterministic — important for grounded RAG
    )

    prompt = ChatPromptTemplate.from_template(RAG_PROMPT_TEMPLATE)

    # 4. Compose the chain: format context → fill prompt → call LLM → parse
    context_str = format_context(retrieved_docs)

    rag_chain = (
                    {
                        "context": lambda _: context_str,
                        "question": RunnablePassthrough(),
                    }
                    | prompt
                    | llm
                    | StrOutputParser()
                )

    # 5. Generate answer
    print("\n" + "=" * 70)
    print("ANSWER")
    print("=" * 70)
    answer = rag_chain.invoke(question)
    print(answer)
    print("=" * 70 + "\n")

    return answer


if __name__ == "__main__":
    if len(sys.argv) > 1:
        # Query passed as a command-line argument
        query = " ".join(sys.argv[1:])
    else:
        # Interactive prompt
        query = input("Enter your question: ").strip()

    if not query:
        print("No question provided. Exiting.")
        sys.exit(1)

    run_query(query)
