#!/bin/bash

# Download localai model--I


LOCALAI=http://localhost:8080
curl $LOCALAI/models/apply -H "Content-Type: application/json" -d '{
     "id": "localai@bert-embeddings"
   }'

