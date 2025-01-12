#!/bin/sh


# Installing ollama
echo " "
echo " "
echo "------"
echo "Installing ollama. Take time...."
echo "When asked, supply password"
echo "------"
echo " "
echo " "
curl -fsSL https://ollama.com/install.sh | sh
sleep 9


# Install langflow
echo " "
echo "Installing langflow..."
echo "------"
echo " "
sleep 9
uv venv
uv pip install langflow 
sleep 4

# 2.1 Install Flowise as NORMAL user
echo " "
echo "Installing flowvise...Takes time..."
echo "------"
echo " "
sleep 9
npm install -g flowise



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
echo "Read script4.sh for tests"
echo "----------"
echo " "
sleep 10
wsl.exe --shutdown


