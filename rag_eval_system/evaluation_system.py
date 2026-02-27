"""
evaluation_system.py
Sub-system 2 — RAG Evaluation pipeline.
location: /home/ashok/Documents/rag_eval_system/

Reads question-answer pairs from data.csv, feeds each question to the RAG
sub-system, and uses deepseek-r1:latest as a judge LLM to compare the RAG
response against the ideal answer using four defined criteria.
Results are appended row-by-row to evaluation_results.txt.

Usage:
  python evaluation_system.py
  python evaluation_system.py --csv /path/to/custom.csv
"""

import argparse
import os
import sys
from datetime import datetime

import pandas as pd
from llama_index.llms.ollama import Ollama

import config

# Import the RAG query function from sub-system 1
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from rag_system import configure_settings, query_rag


# ─────────────────────────────────────────────
# Judge LLM prompt template
# ─────────────────────────────────────────────

_JUDGE_PROMPT_TMPL = """You are an expert evaluator assessing the quality of a RAG (Retrieval-Augmented Generation) system's response.

You are given:
1. A QUESTION that was posed to the RAG system.
2. The RAG RESPONSE produced by the RAG system.
3. The IDEAL ANSWER (ground-truth answer).

Your task is to compare the RAG Response against the Ideal Answer and classify the comparison under EXACTLY ONE of the following four criteria:

Criteria 1: The RAG response and the Ideal Answer contain the same information. The RAG response is complete and accurate with no missing or extra information.

Criteria 2: The RAG response is MISSING certain information that is present in the Ideal Answer. The RAG response is incomplete but does not contain extra/incorrect information.

Criteria 3: The RAG response contains ALL the information present in the Ideal Answer AND ALSO contains extra information NOT present in the Ideal Answer. The RAG response is complete but adds additional content.

Criteria 4: The RAG response is BOTH deficient (missing some information from the Ideal Answer) AND contains extra information NOT present in the Ideal Answer. The RAG response is partially incorrect and partially incomplete.

---
QUESTION:
{question}

RAG RESPONSE:
{rag_response}

IDEAL ANSWER:
{ideal_answer}
---

Instructions:
- First, briefly analyse what information is present in the RAG Response vs the Ideal Answer.
- Then state which single criteria (1, 2, 3, or 4) best describes the comparison.
- Provide a concise explanation (2-5 sentences) justifying your choice.

Your output MUST follow this exact format:
CRITERIA: [1 / 2 / 3 / 4]
ANALYSIS: [your brief analysis]
JUSTIFICATION: [your explanation of why this criteria applies]
"""


# ─────────────────────────────────────────────
# Helpers
# ─────────────────────────────────────────────

def get_judge_llm() -> Ollama:
    """Instantiate the judge LLM (deepseek-r1:latest via Ollama)."""
    return Ollama(
        model=config.JUDGE_LLM_MODEL,
        base_url=config.OLLAMA_BASE_URL,
        temperature=config.JUDGE_LLM_TEMPERATURE,
        request_timeout=config.REQUEST_TIMEOUT,
    )


def evaluate_row(
    row_num: int,
    question: str,
    rag_response: str,
    ideal_answer: str,
    judge_llm: Ollama,
) -> str:
    """
    Feed the RAG response and ideal answer to the judge LLM.
    Returns a formatted evaluation string ready to be written to the results file.
    """
    prompt = _JUDGE_PROMPT_TMPL.format(
        question=question,
        rag_response=rag_response,
        ideal_answer=ideal_answer,
    )
    judge_output = judge_llm.complete(prompt)
    judge_text = str(judge_output).strip()

    # Format the evaluation block
    separator = "=" * 70
    block = (
        f"\n{separator}\n"
        f"EVALUATION — Row {row_num}\n"
        f"Timestamp : {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n"
        f"{separator}\n"
        f"\nQUESTION:\n{question}\n"
        f"\nRAG RESPONSE:\n{rag_response}\n"
        f"\nIDEAL ANSWER:\n{ideal_answer}\n"
        f"\nJUDGE EVALUATION:\n{judge_text}\n"
        f"{separator}\n"
    )
    return block


def append_to_results(content: str, filepath: str):
    """Append content to the evaluation results file."""
    with open(filepath, "a", encoding="utf-8") as f:
        f.write(content)


# ─────────────────────────────────────────────
# Main evaluation loop
# ─────────────────────────────────────────────

def run_evaluation(csv_path: str):
    """
    Main evaluation loop:
      1. Read data.csv row by row.
      2. Feed 'question' to RAG sub-system.
      3. Feed RAG response + idealAnswer to judge LLM.
      4. Append results to evaluation_results.txt.
    """
    # Validate CSV
    if not os.path.isfile(csv_path):
        print(f"[ERROR] CSV file not found: {csv_path}")
        sys.exit(1)

    df = pd.read_csv(csv_path)

    # Validate required columns
    required_cols = {"question", "idealAnswer"}
    missing = required_cols - set(df.columns)
    if missing:
        print(f"[ERROR] CSV is missing columns: {missing}")
        print(f"        Found columns: {list(df.columns)}")
        sys.exit(1)

    total_rows = len(df)
    print(f"[INFO] Loaded {total_rows} row(s) from {csv_path}.")

    # Configure LlamaIndex global settings (LLM + embed model)
    configure_settings()

    # Instantiate the judge LLM
    judge_llm = get_judge_llm()

    # Write header to results file
    results_path = config.EVAL_RESULTS
    with open(results_path, "a", encoding="utf-8") as f:
        f.write(
            f"\n{'#'*70}\n"
            f"  EVALUATION RUN STARTED: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n"
            f"  Source CSV : {csv_path}\n"
            f"  Total rows : {total_rows}\n"
            f"{'#'*70}\n"
        )

    # Iterate rows
    for idx, row in df.iterrows():
        row_num = idx + 1
        question     = str(row.get("question", "")).strip()
        ideal_answer = str(row.get("idealAnswer", "")).strip()

        if not question:
            print(f"[WARN] Row {row_num}: empty question — skipping.")
            continue

        print(f"\n[INFO] ── Row {row_num}/{total_rows} ──────────────────────")
        print(f"[INFO] Question: {question[:100]}{'...' if len(question) > 100 else ''}")

        # Step iii-a: query the RAG sub-system
        print("[INFO] Querying RAG sub-system …")
        try:
            rag_response = query_rag(question)
        except Exception as e:
            rag_response = f"[RAG ERROR] {e}"
            print(f"[ERROR] RAG query failed: {e}")

        print(f"[INFO] RAG response obtained ({len(rag_response)} chars).")

        # Step iii-b: judge LLM evaluation
        print("[INFO] Sending to judge LLM for evaluation …")
        try:
            eval_block = evaluate_row(
                row_num=row_num,
                question=question,
                rag_response=rag_response,
                ideal_answer=ideal_answer,
                judge_llm=judge_llm,
            )
        except Exception as e:
            eval_block = (
                f"\n{'='*70}\n"
                f"EVALUATION — Row {row_num}  [JUDGE ERROR]\n"
                f"Error: {e}\n"
                f"{'='*70}\n"
            )
            print(f"[ERROR] Judge LLM failed: {e}")

        # Step iii-c: append to results file
        append_to_results(eval_block, results_path)
        print(f"[INFO] ✅ Row {row_num} evaluation written to {results_path}.")

    # Write footer
    with open(results_path, "a", encoding="utf-8") as f:
        f.write(
            f"\n{'#'*70}\n"
            f"  EVALUATION RUN COMPLETED: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n"
            f"  Total rows processed: {total_rows}\n"
            f"{'#'*70}\n"
        )

    print(f"\n[INFO] 🎉 Evaluation complete. Results saved to: {results_path}")


# ─────────────────────────────────────────────
# CLI entry point
# ─────────────────────────────────────────────

def main():
    parser = argparse.ArgumentParser(
        description="RAG Evaluation Sub-system (deepseek-r1 judge LLM)"
    )
    parser.add_argument(
        "--csv",
        type=str,
        default=config.EVAL_CSV,
        help=f"Path to the evaluation CSV file (default: {config.EVAL_CSV})",
    )
    args = parser.parse_args()
    run_evaluation(csv_path=args.csv)


if __name__ == "__main__":
    main()
