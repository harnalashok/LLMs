"""
main.py
-------
Interactive CLI entry point for the RAG system.

Options:
  1. Ingest documents  — embed & store all markdown files in dataFolder/
  2. Ask a question    — retrieve context from PostgreSQL and get a grounded answer
  3. Ingest then query — run both steps in sequence
  4. Quit
"""

import sys
from ingest import ingest
from rag_query import run_query


BANNER = r"""
╔══════════════════════════════════════════════════════════════╗
║              RAG System — Powered by Ollama + pgvector       ║
║   LLM: llama3.2  |  Embeddings: nomic-embed-text             ║
╚══════════════════════════════════════════════════════════════╝
"""

MENU = """
What would you like to do?
  [1] Ingest documents  (embed dataFolder/*.md → PostgreSQL)
  [2] Ask a question    (query the vector store)
  [3] Ingest then query (do both in sequence)
  [4] Quit
"""


def main():
    print(BANNER)

    while True:
        print(MENU)
        choice = input("Enter choice [1/2/3/4]: ").strip()

        if choice == "1":
            ingest()

        elif choice == "2":
            question = input("\nEnter your question: ").strip()
            if not question:
                print("No question entered. Returning to menu.")
                continue
            run_query(question)

        elif choice == "3":
            ingest()
            print()
            question = input("Enter your question: ").strip()
            if not question:
                print("No question entered. Returning to menu.")
                continue
            run_query(question)

        elif choice == "4":
            print("Goodbye!")
            sys.exit(0)

        else:
            print("Invalid choice. Please enter 1, 2, 3, or 4.")

        # Ask if the user wants to continue after each action
        again = input("\nReturn to main menu? [y/n]: ").strip().lower()
        if again not in ("y", "yes", ""):
            print("Goodbye!")
            sys.exit(0)


if __name__ == "__main__":
    main()
