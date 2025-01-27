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

sleep 2
