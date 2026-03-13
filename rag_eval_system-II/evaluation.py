"""
evaluation.py — Sub-system 2: RAG Evaluation Pipeline

Reads question-answer pairs from data.csv, queries the RAG sub-system for each
question, then uses LlamaIndex evaluation modules and a Judge LLM (deepseek-r1)
to score Correctness, Faithfulness, Relevancy, and Semantic Similarity.

Results are appended to evaluation_results.csv.
"""

import csv
import logging
import os
from datetime import datetime

from llama_index.core import Settings
from llama_index.llms.ollama import Ollama
from llama_index.embeddings.ollama import OllamaEmbedding
from llama_index.core.evaluation import (
    CorrectnessEvaluator,
    FaithfulnessEvaluator,
    RelevancyEvaluator,
    SemanticSimilarityEvaluator,
)

from config import (
    OLLAMA_BASE_URL,
    JUDGE_LLM_MODEL,
    EMBED_MODEL,
    DATA_CSV,
    EVAL_RESULTS,
)
from rag_system import load_index, query_rag

logging.basicConfig(level=logging.INFO, format="%(asctime)s [%(levelname)s] %(message)s")
logger = logging.getLogger(__name__)

# ── Result CSV columns ─────────────────────────────────────────────────────────
RESULT_COLUMNS = [
    "timestamp",
    "question",
    "ideal_answer",
    "rag_answer",
    "context_used",
    # Correctness
    "correctness_score",
    "correctness_passing",
    "correctness_feedback",
    # Faithfulness
    "faithfulness_score",
    "faithfulness_passing",
    "faithfulness_feedback",
    # Relevancy
    "relevancy_score",
    "relevancy_passing",
    "relevancy_feedback",
    # Semantic Similarity
    "semantic_similarity_score",
    "semantic_similarity_passing",
]


# ── Setup ─────────────────────────────────────────────────────────────────────

def _init_judge_llm() -> Ollama:
    """Instantiate the Judge LLM (deepseek-r1)."""
    judge_llm = Ollama(
        model=JUDGE_LLM_MODEL,
        base_url=OLLAMA_BASE_URL,
        request_timeout=600.0,   # deepseek-r1 reasoning may take longer
    )
    logger.info("Judge LLM initialised: %s", JUDGE_LLM_MODEL)
    return judge_llm


def _init_embed_model() -> OllamaEmbedding:
    """Embedding model used by SemanticSimilarityEvaluator."""
    return OllamaEmbedding(
        model_name=EMBED_MODEL,
        base_url=OLLAMA_BASE_URL,
        request_timeout=120.0,
    )


def _ensure_results_file() -> bool:
    """Create the CSV results file with headers if it does not yet exist.

    Returns:
        True if the file was newly created, False if it already existed.
    """
    if not os.path.exists(EVAL_RESULTS):
        with open(EVAL_RESULTS, "w", newline="", encoding="utf-8") as f:
            writer = csv.DictWriter(f, fieldnames=RESULT_COLUMNS)
            writer.writeheader()
        logger.info("Created evaluation results file: %s", EVAL_RESULTS)
        return True
    return False


def _safe_score(result) -> float:
    """Extract numeric score from an EvaluationResult, defaulting to 0.0."""
    try:
        if result is None:
            return 0.0
        score = result.score
        return float(score) if score is not None else 0.0
    except Exception:
        return 0.0


def _safe_passing(result) -> bool:
    """Extract passing flag from an EvaluationResult, defaulting to False."""
    try:
        if result is None:
            return False
        return bool(result.passing)
    except Exception:
        return False


def _safe_feedback(result) -> str:
    """Extract feedback text from an EvaluationResult."""
    try:
        if result is None:
            return ""
        return str(result.feedback or "").replace("\n", " ").strip()
    except Exception:
        return ""


# ── Core evaluation logic ─────────────────────────────────────────────────────

def evaluate_single(
    question: str,
    ideal_answer: str,
    rag_result: dict,
    judge_llm: Ollama,
    embed_model: OllamaEmbedding,
) -> dict:
    """
    Run all evaluators for a single question and return a result dict.

    Args:
        question:     The user question.
        ideal_answer: Ground-truth answer from data.csv.
        rag_result:   Output of query_rag(): {"question", "context", "answer"}.
        judge_llm:    The Judge LLM instance.
        embed_model:  Embedding model for semantic similarity.

    Returns:
        dict matching RESULT_COLUMNS.
    """
    rag_answer = rag_result["answer"]
    context_chunks = rag_result["context"]
    # Joint context string for evaluators that expect a single string
    context_str = "\n\n---\n\n".join(context_chunks)

    row = {
        "timestamp": datetime.now().isoformat(timespec="seconds"),
        "question": question,
        "ideal_answer": ideal_answer,
        "rag_answer": rag_answer,
        "context_used": context_str[:1000] + "..." if len(context_str) > 1000 else context_str,
        "correctness_score": 0.0,
        "correctness_passing": False,
        "correctness_feedback": "",
        "faithfulness_score": 0.0,
        "faithfulness_passing": False,
        "faithfulness_feedback": "",
        "relevancy_score": 0.0,
        "relevancy_passing": False,
        "relevancy_feedback": "",
        "semantic_similarity_score": 0.0,
        "semantic_similarity_passing": False,
    }

    # ── 1. Correctness (answer vs ideal answer) ────────────────────────────
    logger.info("  Running CorrectnessEvaluator...")
    try:
        correctness_eval = CorrectnessEvaluator(llm=judge_llm)
        corr_result = correctness_eval.evaluate(
            query=question,
            response=rag_answer,
            reference=ideal_answer,
        )
        row["correctness_score"]    = _safe_score(corr_result)
        row["correctness_passing"]  = _safe_passing(corr_result)
        row["correctness_feedback"] = _safe_feedback(corr_result)
        logger.info("  Correctness score: %.3f | passing: %s", row["correctness_score"], row["correctness_passing"])
    except Exception as e:
        logger.warning("  CorrectnessEvaluator failed: %s", e)

    # ── 2. Faithfulness (answer grounded in context?) ──────────────────────
    logger.info("  Running FaithfulnessEvaluator...")
    try:
        faithfulness_eval = FaithfulnessEvaluator(llm=judge_llm)
        faith_result = faithfulness_eval.evaluate(
            query=question,
            response=rag_answer,
            contexts=[context_str],
        )
        row["faithfulness_score"]    = _safe_score(faith_result)
        row["faithfulness_passing"]  = _safe_passing(faith_result)
        row["faithfulness_feedback"] = _safe_feedback(faith_result)
        logger.info("  Faithfulness score: %.3f | passing: %s", row["faithfulness_score"], row["faithfulness_passing"])
    except Exception as e:
        logger.warning("  FaithfulnessEvaluator failed: %s", e)

    # ── 3. Relevancy (retrieved context relevant to question?) ─────────────
    logger.info("  Running RelevancyEvaluator...")
    try:
        relevancy_eval = RelevancyEvaluator(llm=judge_llm)
        rel_result = relevancy_eval.evaluate(
            query=question,
            response=rag_answer,
            contexts=[context_str],
        )
        row["relevancy_score"]    = _safe_score(rel_result)
        row["relevancy_passing"]  = _safe_passing(rel_result)
        row["relevancy_feedback"] = _safe_feedback(rel_result)
        logger.info("  Relevancy score: %.3f | passing: %s", row["relevancy_score"], row["relevancy_passing"])
    except Exception as e:
        logger.warning("  RelevancyEvaluator failed: %s", e)

    # ── 4. Semantic Similarity (embedding-based answer vs ideal) ───────────
    logger.info("  Running SemanticSimilarityEvaluator...")
    try:
        sem_sim_eval = SemanticSimilarityEvaluator(embed_model=embed_model)
        sem_result = sem_sim_eval.evaluate(
            response=rag_answer,
            reference=ideal_answer,
        )
        row["semantic_similarity_score"]   = _safe_score(sem_result)
        row["semantic_similarity_passing"] = _safe_passing(sem_result)
        logger.info("  Semantic similarity score: %.3f | passing: %s", row["semantic_similarity_score"], row["semantic_similarity_passing"])
    except Exception as e:
        logger.warning("  SemanticSimilarityEvaluator failed: %s", e)

    return row


def _append_result(row: dict) -> None:
    """Append a single result row to the evaluation results CSV."""
    with open(EVAL_RESULTS, "a", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=RESULT_COLUMNS)
        writer.writerow(row)


# ── Main entry point ──────────────────────────────────────────────────────────

def run_evaluation() -> None:
    """
    Main evaluation loop:
      1. Load the Judge LLM and embedding model.
      2. Load the RAG index.
      3. Read data.csv row by row.
      4. For each row: query RAG → evaluate → append to evaluation_results.csv.
    """
    logger.info("=== Starting RAG Evaluation Pipeline ===")
    logger.info("Judge LLM: %s | Data file: %s", JUDGE_LLM_MODEL, DATA_CSV)

    # Initialise models
    judge_llm   = _init_judge_llm()
    embed_model = _init_embed_model()

    # Ensure results file exists (with header)
    _ensure_results_file()

    # Load the RAG index once (reused across all questions)
    logger.info("Loading RAG index from PostgreSQL...")
    rag_index = load_index()
    logger.info("RAG index loaded successfully.")

    # Read data.csv
    if not os.path.exists(DATA_CSV):
        raise FileNotFoundError(f"data.csv not found at: {DATA_CSV}")

    with open(DATA_CSV, "r", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        rows = list(reader)

    total = len(rows)
    logger.info("Found %d question(s) in data.csv. Starting evaluation...", total)

    for idx, data_row in enumerate(rows, start=1):
        question     = data_row.get("question", "").strip()
        ideal_answer = data_row.get("idealAnswer", "").strip()

        if not question:
            logger.warning("Row %d/%d: Empty question — skipping.", idx, total)
            continue

        logger.info("── Question %d/%d ──────────────────────────────────────", idx, total)
        logger.info("  Q: %s", question)

        # Step 1: Query the RAG system
        try:
            rag_result = query_rag(question, index=rag_index)
        except Exception as e:
            logger.error("  RAG query FAILED for question %d: %s", idx, e)
            continue

        # Step 2: Evaluate
        result_row = evaluate_single(
            question=question,
            ideal_answer=ideal_answer,
            rag_result=rag_result,
            judge_llm=judge_llm,
            embed_model=embed_model,
        )

        # Step 3: Append to CSV
        _append_result(result_row)
        logger.info(
            "  Saved result for Q%d | Correctness=%.2f | Faith=%.2f | Rel=%.2f | SemSim=%.2f",
            idx,
            result_row["correctness_score"],
            result_row["faithfulness_score"],
            result_row["relevancy_score"],
            result_row["semantic_similarity_score"],
        )

    logger.info("=== Evaluation complete. Results saved to: %s ===", EVAL_RESULTS)
    _print_summary()


def _print_summary() -> None:
    """Print a summary table of evaluation results from the CSV file."""
    if not os.path.exists(EVAL_RESULTS):
        return
    print("\n" + "=" * 80)
    print(f"{'EVALUATION SUMMARY':^80}")
    print("=" * 80)
    fmt = "{:<4} {:<45} {:>8} {:>8} {:>8} {:>8}"
    print(fmt.format("#", "Question (truncated)", "Correct", "Faith", "Relev", "SemSim"))
    print("-" * 80)
    with open(EVAL_RESULTS, "r", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for i, row in enumerate(reader, 1):
            q = row.get("question", "")[:43] + ".." if len(row.get("question", "")) > 45 else row.get("question", "")
            print(fmt.format(
                i,
                q,
                f"{float(row.get('correctness_score', 0)):.2f}",
                f"{float(row.get('faithfulness_score', 0)):.2f}",
                f"{float(row.get('relevancy_score', 0)):.2f}",
                f"{float(row.get('semantic_similarity_score', 0)):.2f}",
            ))
    print("=" * 80 + "\n")


if __name__ == "__main__":
    run_evaluation()
