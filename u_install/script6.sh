#!/bin/bash

# Install langchain and langgraph

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
deactivate
# Create script
echo "echo 'Call as: source venv_langchain.sh' " > venv_langchain.sh
echo "source /home/ashok/langchain/bin/activate"  >> venv_langchain.sh
sleep 2
