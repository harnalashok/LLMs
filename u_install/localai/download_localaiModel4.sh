#!/bin/bash

# Download localai model--IV
# Better download it directly from localai models gallery


LOCALAI=http://localhost:8080
curl $LOCALAI/models/apply -H "Content-Type: application/json" -d '{
     "id": "mistral-7b-instruct-v0.3"
   }'

echo " "
echo "To check download status, execute: ./get_download_status.sh "   
echo " "
