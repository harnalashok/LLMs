#!/bin/bash

# Download stable diffusion model for image generation
# Ref: https://localai.io/features/image-generation/


LOCALAI=http://localhost:8080
curl http://localhost:8080/models/apply -H "Content-Type: application/json" -d '{
  "url": "github:go-skynet/model-gallery/stablediffusion.yaml"
}'

echo " "
echo "To check download status, execute: ./get_download_status.sh "   
echo " "
