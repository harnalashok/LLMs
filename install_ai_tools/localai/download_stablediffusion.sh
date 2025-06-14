#!/bin/bash

# Download stable diffusion model for image generation
# Ref: https://localai.io/features/image-generation/


LOCALAI=http://localhost:8080
curl http://localhost:8080/models/apply -H "Content-Type: application/json" -d '{
  "url": "github:go-skynet/model-gallery/stablediffusion.yaml"
}'

echo " "
echo "Downloaded models are stored here:"
echo "       /var/lib/docker/volumes/12518350e14a619d6c5412073fec2a2988d41ea582780244d168c6d8ccef5229/_data/"
echo "To check download status, execute: ./get_download_status.sh "   
echo " "
