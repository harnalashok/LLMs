# Vector Databases

## What is a Vector Database?

A vector database is a specialized database designed to store, index, and retrieve high-dimensional
vector embeddings efficiently. Unlike traditional relational databases that search by exact value
matches, vector databases perform **approximate nearest-neighbor (ANN)** searches to find vectors
most similar to a query vector.

## Why Vector Databases?

Traditional databases cannot efficiently handle similarity search over millions of high-dimensional
vectors. Vector databases use specialized indexing algorithms to make this fast and scalable.

## How They Work

1. **Embedding**: Source documents (text, images, audio, etc.) are converted into vectors using
   embedding models.
2. **Indexing**: Vectors are stored in the database using specialized index structures (e.g., HNSW,
   IVF, or Flat Index).
3. **Querying**: A query is embedded using the same model. The database returns the top-K vectors
   most similar to the query vector based on a distance metric (cosine similarity, dot product, etc.).

## Common Vector Databases

| Database      | Type                | Key Feature                        |
|--------------|---------------------|------------------------------------|
| pgvector     | PostgreSQL extension| SQL-native, relational + vector    |
| ChromaDB     | Open-source         | Lightweight, embedded or server    |
| Qdrant       | Open-source         | High performance, filtering support|
| Faiss        | Library (Meta)      | GPU support, large-scale           |
| Weaviate     | Open-source         | Multi-modal, GraphQL API           |
| Pinecone     | Managed SaaS        | Fully managed, scalable            |

## pgvector

**pgvector** is a PostgreSQL extension that adds vector similarity search capabilities to the
PostgreSQL relational database. It supports:
- Storing vectors as a native `vector` data type.
- Exact nearest-neighbor search using cosine, L2, and inner product distance.
- Approximate nearest-neighbor search using HNSW and IVF indexes.

### Setup in PostgreSQL
```sql
CREATE EXTENSION IF NOT EXISTS vector;
CREATE TABLE embeddings (
    id SERIAL PRIMARY KEY,
    content TEXT,
    embedding vector(768)
);
```

### Advantages of pgvector
- No separate vector database infrastructure required.
- Combines vector search with standard SQL queries (filtering, joins).
- Well-supported by LlamaIndex via `llama-index-vector-stores-postgres`.

## Distance Metrics

- **Cosine similarity**: Measures the angle between two vectors. Values range from -1 to 1 (1 = identical direction).
- **L2 (Euclidean) distance**: Measures straight-line distance between vector endpoints.
- **Dot product (inner product)**: Useful when vectors are normalized.

## Use Cases

- **Semantic search**: Finding documents semantically similar to a query.
- **Recommendation systems**: Suggesting items similar to what a user has interacted with.
- **RAG pipelines**: Retrieving relevant context chunks for LLM question answering.
- **Duplicate detection**: Finding near-duplicate content.
- **Image and audio search**: Matching across non-text modalities using multi-modal embeddings.
