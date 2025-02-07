#!/bin/bash

# Download Generate images
# Ref: https://localai.io/features/image-generation/
# stablediffusioan model needs to be pre-installed


# 512x512 is supported too
curl http://localhost:8080/v1/images/generations -H "Content-Type: application/json" -d '{
  "prompt": "A cute baby sea otter",
  "size": "256x256"
}'
