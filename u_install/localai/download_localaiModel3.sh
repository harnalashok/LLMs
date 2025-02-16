#!/bin/bash

# Download localai model--III
# Better download it directly from localai models gallery


LOCALAI=http://localhost:8080
curl $LOCALAI/models/apply -H "Content-Type: application/json" -d '{
     "id": "moondream2"
   }'

echo " "
echo "To check download status, execute: ./get_download_status.sh "   
echo " "   

