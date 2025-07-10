#!/bin/bash

# Download localai model--I
echo " "
echo "Actual model is: Llama-3.2-1B-Instruct-Q4_K_M-GGUF"
echo "llama3.2 embeddings model"
echo "Can be used as drop-in replacement for bert-embeddings" 
echo "Hence the name bert-embeddings"
echo " "
sleep 4

LOCALAI=http://localhost:8080
curl $LOCALAI/models/apply -H "Content-Type: application/json" -d '{
     "id": "localai@bert-embeddings"
   }'
   
echo " "
echo " "
echo "Downloaded models are stored here:"
echo "       /var/lib/docker/volumes/12518350e14a619d6c5412073fec2a2988d41ea582780244d168c6d8ccef5229/_data/"
echo "To check download status, execute: ./get_download_status.sh "   
echo " "

