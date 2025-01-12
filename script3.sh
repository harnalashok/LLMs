#!/bin/sh


# These sscripts run in sequence.
#     script0.sh
#     script1.sh
#     script2.sh
#     script3.sh
#     script4.sh
#     docker_install.sh


if [[ `which ollama` == "/usr/local/bin/ollama" ]]; then
   echo "Possibly script3.sh was earlier executed. Recheck..."
   echo "Press ctrl+c to break now"
   sleep 50
fi


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
echo "Download size is 637MB"
echo "------"
echo " "
ollama pull tinyllama

echo " "
echo "Will shut down Ubuntu console"
echo "Reopen it and install docker, as:"
echo "  ./docker_install.sh"
echo "----------"
echo " "
sleep 10
wsl.exe --shutdown


