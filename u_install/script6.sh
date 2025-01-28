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

# Move scripts
mv /home/ashok/script6.sh  /home/ashok/done/
mv /home/ashok/next/download_models.sh   /home/ashok/


# Install openwebui
# Ref: https://github.com/open-webui/open-webui?tab=readme-ov-file#installation-via-python-pip-

# Check existing python versions
echo "Existing python versions on your machine are are as below"
echo " "

ls /usr/bin/python*

read -p "Do you want to continue to install python3.11 ? " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi
echo " "
echo "---------"
echo "Installing python3.11"
echo "----- "
sleep 4

# Install python 3.11 now
sudo apt install python3.11 -y

# Install tool to create python venv
# invokable with its own Python executable

sudo apt install python3.11-venv  -y

# Check again python versions
echo "Installed python versions now are:"
echo " "
ls /usr/bin/python*
sleep 4

# Create python virtual env at openwebui
echo "Creating python virtual env at openwebui"
# Using python3.11 package
python3.11 -m venv /home/ashok/openwebui

echo "Activating the new python env"
# Activate the python env
source /home/ashok/openwebui/bin/activate
sleep 2

echo "Installing openwebui....Takes lots of time...."
sleep 4
# Install openwebui. Takes time
pip3.11 install open-webui

echo " "
echo " "
echo "------------"
echo "Done. Starting openwebui........"
echo "Access it at port 7860"
echo " You can kill it after starting"
sleep 9

# Create script to start openwebui
echo "source /home/ashok/openwebui/bin/activate" > openwebui_start.sh
echo "open-webui serve"                          >> openwebui_start.sh
chmod +x /home/ashok/*.sh


# Start open-webui once
open-webui serve



echo "You may like to execute:"
echo "       ./download_models.sh"
sleep 10
kill $PPID




