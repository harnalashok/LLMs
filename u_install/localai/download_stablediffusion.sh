#!/bin/bash

# Download stable diffusion model for image generation


LOCALAI=http://localhost:8080
curl http://localhost:8080/models/apply -H "Content-Type: application/json" -d '{
  "url": "github:go-skynet/model-gallery/stablediffusion.yaml"
}'
