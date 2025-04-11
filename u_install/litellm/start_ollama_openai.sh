#!/bin/bash
# Shift to python virtual environment
source /home/ashok/langchain/bin/activate
# Let litellm server access ollama through its API
echo " "
echo "========"
echo "Litellm would make ollama model behave as if it"
echo "is an OpenAI model. Ollama model being accessed is:"
echo "mistral:latest."
echo "Change this model by editing file: ~/litellm/config_ollama.yaml"
echo "========="
echo " "
sleep 5
litellm --config /home/ashok/litellm/config_ollama.yaml
