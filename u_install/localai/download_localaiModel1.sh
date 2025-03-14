#!/bin/bash

# Download localai model--I
echo " "
echo "Actual model is: Llama-3.2-1B-Instruct-Q4_K_M-GGUF"
echo "llama3.2 embeddings model"
echo "Can be used as drop-in replacement for bert-embeddings" 
echo " "
sleep 4

LOCALAI=http://localhost:8080
curl $LOCALAI/models/apply -H "Content-Type: application/json" -d '{
     "id": "localai@bert-embeddings"
   }'
   
echo " "
echo " "
echo "To check download status, execute: ./get_download_status.sh "   
echo " "

