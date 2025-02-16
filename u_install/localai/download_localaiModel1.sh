#!/bin/bash

# Download localai model--I

LOCALAI=http://localhost:8080
curl $LOCALAI/models/apply -H "Content-Type: application/json" -d '{
     "id": "localai@bert-embeddings"
   }'
   
echo " "
echo " "
echo "To check download status, execute: ./get_download_status.sh "   
echo " "

