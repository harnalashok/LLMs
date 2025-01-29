#!/bin/bash

# Install langchain and llamaindex
# 

echo "========script6=============="
echo "Will install langchain"
echo "Will install LangGraph"
echo "Will install LangServe"
echo "Will install LangChain CLI"
echo "Will install LlamaIndex"
echo "Will install Open WebUI--needs ollama behind the scenes"
echo "You may call download_models.sh to download gguf models or from ollama library"
echo "==========================="
sleep 10

cd ~/

# Create python environment at 'langchain'
#  for installing langchain and llama-index

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
echo "Installing llama-index"
echo
pip install llama-index
# Ollama and huggingface oriented
pip install llama-index-core llama-index-readers-file llama-index-llms-ollama llama-index-embeddings-huggingface
sleep 2

# Deactivate the environment
deactivate

# Create script to activate 'langchain' env
echo "echo 'Call as: source venv_langchain.sh' " > venv_langchain.sh
echo "source /home/ashok/langchain/bin/activate"  >> venv_langchain.sh
sleep 2

# Move scripts
mv /home/ashok/script6.sh  /home/ashok/done/
mv /home/ashok/next/download_models.sh   /home/ashok/


# Install openwebui using pip. Refer its github site
# Ref: https://github.com/open-webui/open-webui?tab=readme-ov-file#installation-via-python-pip-
# OpenWebUI utilizes Ollama to run GGUF models, so you'll need to be familiar 
#  with Ollama's functionality to fully manage your GGUF models

echo " "
echo "---------------"
echo "Will begin installing open-webui. Python version needed is exactly 3.11"
echo "Note: Open WebUI connects to Ollama to work with"
echo "Better install ollama if not already installed."
echo "---------------"
echo " "
sleep 9
# Check existing installed python versions on your machine
echo "Existing python versions on your machine are are as below"
echo " "

ls /usr/bin/ | grep python

read -p "Do you want to continue to install python3.11 ? " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi
echo " "
echo "---------"
echo "Installing python3.11"
echo "Open Webui needs python3.11"
echo "----- "
sleep 4

# Install python 3.11 now
sudo apt update
sudo apt install python3.11 -y

# Install tool to create python venv
# invokable with its own Python executable

sudo apt install python3.11-venv  -y

# Check again python versions
echo "Installed python versions now are:"
echo " "
ls /usr/bin/ | grep python
sleep 9

# Create python virtual env at openwebui
echo "Creating python virtual env at openwebui"
# Using python3.11 package
python3.11 -m venv /home/ashok/openwebui

echo "Activating the new python env"
# Activate the python env
source /home/ashok/openwebui/bin/activate
sleep 2

echo "--------------"
echo "Installing openwebui....Takes lots of time...."
echo "If it breaks, try again....."
echo "--------------"
echo " "
sleep 9

# Installing openwebui. Takes time
pip3.11 install open-webui

echo " "
echo " "
echo "------------"
echo "Done. Starting openwebui........"
echo "During initial startup it imports many files"
echo "Access it at port 7860"
echo "You can kill it after starting with ctrl+c"
echo "------------"
echo " "
sleep 9

# Create script to start openwebui thenext time
# Activate the env
echo "source /home/ashok/openwebui/bin/activate" > openwebui_start.sh
echo "open-webui serve"                          >> openwebui_start.sh
chmod +x /home/ashok/*.sh

# Start open-webui once
open-webui serve

deactivate

echo "You may like to execute:"
echo "       ./download_models.sh"
sleep 10
kill $PPID




