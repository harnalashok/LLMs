#!/bin/sh

# Installs langflow
# Last amended: 11th Jan, 2025


# Install langflow
echo " "
echo "Installing langflow..."
echo "------"
echo " "
sleep 4
uv venv
uv pip install langflow 
sleep 3

# Installing ollama
echo " "
echo "Installing ollama"
echo "------"
echo " "
curl -fsSL https://ollama.com/install.sh | sh

sleep 4
# Download tinyllama
echo " "
echo "--------- "
echo "Downloading tinyllama"
echo "------"
echo " "
ollama pull tinyllama

echo " "
echo "Will shut down Ubuntu console"
echo "Reopen it and perform tests"
echo "----------"
echo " "
sleep 4
wsl.exe --shutdown


