#!/bin/bash

# Install langchain and langgraph

echo "========script6=============="
echo "Will install langchain"
echo "Will install LangGraph"
echo "Will install LangServe"
echo "Will install LangChain CLI"
echo "Will install LlamaIndex"
echo "You may call download_models.sh to download gguf models or from ollama library"
echo "==========================="
sleep 10



# Create python environment for installing
python3 -m venv /home/ashok/langchain
source /home/ashok/langchain/bin/activate
pip install langchain
pip install langchain-openai
pip install langchain-community
pip install langchain-experimental
pip install langgraph
pip install "langserve[all]"
pip install langchain-cli

# LLamaindex install
# Mostly openai related
pip install llama-index
# Ollama and huggingface oriented
pip install llama-index-core llama-index-readers-file llama-index-llms-ollama llama-index-embeddings-huggingface

deactivate

# Create script
echo "echo 'Call as: source venv_langchain.sh' " > venv_langchain.sh
echo "source /home/ashok/langchain/bin/activate"  >> venv_langchain.sh
sleep 2

# Move scripts
mv /home/ashok/script6.sh  /home/ashok/done/
mv /home/ashok/next/download_models.sh   /home/ashok/

echo "You may like to execute:"
echo "       ./download_models.sh"
sleep 10
kill $PPID




