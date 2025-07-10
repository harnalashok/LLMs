#!/bin/bash

# Download localai model--III
# Better download it directly from localai models gallery
# It will be named as gpt-3.5-turbo

echo "Will download: gemma-3-4b-it"
LOCALAI=http://localhost:8080
curl $LOCALAI/models/apply -H "Content-Type: application/json" -d '{
     "id": "gemma-3-4b-it",
      "name": "gpt-3.5-turbo"
   }'

echo " "
echo "Model is: gemma-3-4b-it"
echo "Model has a new name: gpt-3.5-turbo "
echo "Downloaded models are stored here:"
echo "       /var/lib/docker/volumes/12518350e14a619d6c5412073fec2a2988d41ea582780244d168c6d8ccef5229/_data/"
echo "To check download status, execute: ./get_download_status.sh "   
echo " "   

