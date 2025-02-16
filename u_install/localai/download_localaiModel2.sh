#!/bin/bash

# Download localai model--III
# Better download it directly from localai models gallery
# It will be named as gpt-3.5-turbo


LOCALAI=http://localhost:8080
curl $LOCALAI/models/apply -H "Content-Type: application/json" -d '{
     "id": "LocalAI-functioncall-phi-4-v0.3",
      "name": "gpt-3.5-turbo"
   }'

echo " "
echo " "
echo "To check download status, execute: ./get_download_status.sh "   
echo " "   

