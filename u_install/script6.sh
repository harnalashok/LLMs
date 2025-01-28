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

cd ~/

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

# Install openwebui
# Check existing python versions
ls /usr/bin/python*

# Install python 3.11
sudo apt install python3.11 -y

# Install tool to create python venv
# invokable with its own Python executable
sudo apt install python3.11-venv  -y

# Check again python versions
ls /usr/bin/python*

# Create python virtual env at openwebui
# Using python3.11 package

python3.11 -m venv /home/ashok/openwebui
# Activate the python env
source /home/ashok/openwebui/bin/activate
# Install openwebui. Takes time
pip3.11 install open-webui

# Start open-webui once
open-webui serve



# Move scripts
mv /home/ashok/script6.sh  /home/ashok/done/
mv /home/ashok/next/download_models.sh   /home/ashok/

echo "You may like to execute:"
echo "       ./download_models.sh"
sleep 10
kill $PPID




