# Large Language Models (LLMs)

## Definition

Large Language Models (LLMs) are a class of deep learning models trained on massive amounts of
text data. They are capable of generating coherent, contextually relevant text, answering questions,
summarizing documents, translating languages, and writing code.

## How LLMs Work

LLMs are typically based on the Transformer architecture, introduced in the 2017 paper
"Attention is All You Need" by Vaswani et al. The core mechanism is **self-attention**, which
allows the model to weigh the relevance of different words in a sentence relative to each other.

### Pre-training
During pre-training, the model is trained on a large corpus of text (books, websites, code, etc.)
using objectives such as next-token prediction (causal language modeling).

### Fine-tuning
After pre-training, models are often fine-tuned on task-specific datasets, or using techniques like:
- **Instruction tuning**: Training on (instruction, response) pairs.
- **RLHF (Reinforcement Learning from Human Feedback)**: Aligning model outputs with human preferences.

## Notable LLMs

| Model       | Organization   | Parameters    |
|-------------|----------------|---------------|
| GPT-4       | OpenAI         | ~1.8 trillion (est.) |
| LLaMA 3.2   | Meta AI        | 3B / 11B      |
| Gemini      | Google DeepMind| Various       |
| Mistral 7B  | Mistral AI     | 7 billion     |
| DeepSeek-R1 | DeepSeek       | 671 billion   |

## Capabilities

- **Text generation**: Writing essays, stories, poetry.
- **Question answering**: Answering factual and reasoning questions.
- **Summarization**: Condensing long documents into key points.
- **Code generation**: Writing, debugging, and explaining code.
- **Translation**: Translating between many languages.

## Limitations

- **Hallucinations**: LLMs can generate plausible-sounding but factually incorrect information.
- **Outdated knowledge**: Models have a training cutoff date and lack real-time information.
- **Context window**: Models can only process a limited number of tokens at once.
- **Bias**: Models may reproduce biases present in training data.

## Retrieval-Augmented Generation (RAG)

RAG is a technique that enhances LLMs by retrieving relevant documents from an external knowledge
base before generating a response. This reduces hallucinations and keeps answers grounded in
verified source documents. RAG systems typically use:
1. An **embedding model** to encode documents and queries into vector representations.
2. A **vector database** to store and retrieve document embeddings.
3. An **LLM** to generate answers based on retrieved context.

## Embeddings

Embeddings are dense numerical representations of text. Models like **nomic-embed-text** convert
sentences or paragraphs into high-dimensional vectors. Similar texts have vectors that are close
together in the embedding space, enabling semantic search.

## Deployment

LLMs can be deployed:
- **In the cloud**: Via APIs (OpenAI, Anthropic, Google).
- **Locally**: Using tools like **Ollama**, which allows running models such as LLaMA 3.2 and
  nomic-embed-text directly on a local machine or server without internet access.
