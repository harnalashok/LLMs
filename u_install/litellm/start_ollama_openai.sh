#!/bin/bash
# Shift to python virtual environment
source /home/ashok/langchain/bin/activate
# Let litellm server access ollama through its API
echo " "
echo "========"
echo "Litellm would make ollama model behave as if it"
echo "is an OpenAI model. Ollama model being accessed is:"
echo "mistral:latest."
echo "Change this model by editing file: ~/litellm/config_ollama.yaml."
echo "In flowise, in node, 'ChatLocaAI', write URL as: http://localhost:4000"
echo "And 'Model Name' as: mistral:latest"
echo "----"
echo "Kill the process by finding its pid, as:"
echo "lsof -i :4000"
echo " "
echo "========="
echo " "
sleep 5
litellm --config /home/ashok/litellm/config_ollama.yaml > /dev/null 2>&1 &
netstat -aunt | grep 4000
