"""
main.py — CLI Entry Point for the integrated RAG + Evaluation system.

Usage:
  python main.py --ingest              # Ingest markdown files into PostgreSQL
  python main.py --query "question"    # Run a single RAG query
  python main.py --evaluate            # Run the full evaluation pipeline
  python main.py --ingest --evaluate   # Ingest then evaluate
"""

import argparse
import sys
import logging

logging.basicConfig(level=logging.INFO, format="%(asctime)s [%(levelname)s] %(message)s")
logger = logging.getLogger(__name__)


def run_ingest() -> None:
    """Ingest markdown documents into PostgreSQL vector store."""
    print("\n" + "=" * 60)
    print("  SUB-SYSTEM 1: Ingesting Documents into Vector Store")
    print("=" * 60)
    from rag_system import ingest
    count = ingest()
    print(f"\n✅  Ingestion complete. {count} document(s) processed.\n")


def run_query(question: str) -> None:
    """Run a single RAG query and display context + answer."""
    print("\n" + "=" * 60)
    print("  SUB-SYSTEM 1: RAG Query")
    print("=" * 60)
    from rag_system import query_rag
    result = query_rag(question)

    print(f"\n📌 QUESTION:\n  {result['question']}\n")

    print("📄 RETRIEVED CONTEXT:")
    if result["context"]:
        for i, chunk in enumerate(result["context"], 1):
            print(f"\n  ── Chunk {i} ──────────────────────────")
            # Print first 500 chars of each chunk
            display = chunk if len(chunk) <= 500 else chunk[:500] + "…"
            for line in display.splitlines():
                print(f"  {line}")
    else:
        print("  (No context retrieved)")

    print(f"\n💬 ANSWER:\n  {result['answer']}\n")


def run_evaluate() -> None:
    """Run the full RAG evaluation pipeline."""
    print("\n" + "=" * 60)
    print("  SUB-SYSTEM 2: RAG Evaluation Pipeline")
    print("=" * 60)
    from evaluation import run_evaluation
    run_evaluation()


def main() -> None:
    parser = argparse.ArgumentParser(
        prog="main.py",
        description="Integrated RAG System + Evaluation Pipeline (LlamaIndex + Ollama + PostgreSQL)",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python main.py --ingest
  python main.py --query "What is Retrieval-Augmented Generation?"
  python main.py --evaluate
  python main.py --ingest --evaluate
        """,
    )
    parser.add_argument(
        "--ingest",
        action="store_true",
        help="Ingest markdown files from dataFolder/ into the PostgreSQL vector store.",
    )
    parser.add_argument(
        "--query",
        type=str,
        metavar="QUESTION",
        help="Ask a single question to the RAG system.",
    )
    parser.add_argument(
        "--evaluate",
        action="store_true",
        help="Run the full evaluation pipeline using data.csv and Judge LLM.",
    )

    args = parser.parse_args()

    if not any([args.ingest, args.query, args.evaluate]):
        parser.print_help()
        sys.exit(0)

    if args.ingest:
        run_ingest()

    if args.query:
        run_query(args.query)

    if args.evaluate:
        run_evaluate()


if __name__ == "__main__":
    main()
