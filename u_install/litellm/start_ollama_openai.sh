#!/bin/bash
# Shift to python virtual environment
source /home/ashok/langchain/bin/activate
# Let litellm server access ollama through its API
litellm --config /home/ashok/litellm/config_ollama.yaml
