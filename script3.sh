#!/bin/sh

# Installs langflow
# Last amended: 11th Jan, 2025


# Install langflow
echo "Installing langflow"
uv venv
uv pip install 
sleep 3

# Install ollama
echo "Install ollama"
curl -fsSL https://ollama.com/install.sh | sh

sleep 3
# Download tinyllama
echo "Downloading tinyllama"
ollama pull tinyllama

