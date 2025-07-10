#!/bin/bash

# Download localai model--IV
# Better download it directly from localai models gallery


LOCALAI=http://localhost:8080
curl $LOCALAI/models/apply -H "Content-Type: application/json" -d '{
     "id": "gemma-3-27b-it"
   }'

echo " "
echo " "
echo "Downloaded models are stored here:"
echo "       /var/lib/docker/volumes/12518350e14a619d6c5412073fec2a2988d41ea582780244d168c6d8ccef5229/_data/"
echo "To check download status, execute: ./get_download_status.sh "   
echo " "
