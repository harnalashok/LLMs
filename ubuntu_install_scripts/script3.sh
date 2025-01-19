#!/bin/bash

# LAst amended: 14th Jan, 2024

# Connected scripts are:
# These sscripts run in sequence.
#     script0.sh
#     script1.sh
#     script2.sh
#     script3.sh
#     docker_install.sh
#     script4.sh
#     script5.sh
#     script6.sh
#     script7.sh


echo " " | tee -a error.log
echo "*********"  | tee -a error.log
echo "Script: script3.sh"  | tee -a error.log
echo "**********" | tee -a error.log
echo " " | tee -a error.log


# Install langflow
echo " "   | tee -a error.log
echo "Installing langflow..."  | tee -a error.log
echo "------"   | tee -a error.log
echo " "   | tee -a error.log
sleep 9
uv venv
uv pip install langflow  2>> error.log
sleep 2
echo "  "    | tee -a error.log
echo "  "    | tee -a error.log
echo "langflow installed"   | tee -a error.log
# https://docs.langflow.org/configuration-cli
echo "Ref: https://docs.langflow.org/configuration-cli"      | tee -a error.log
echo "Run following command to get langflow CLI options:"    | tee -a error.log
echo "        uv run langflow"    | tee -a error.log
echo "Generate api-key, as: "    | tee -a error.log
echo "        uv run langflow api-key"    | tee -a error.log
echo "Run langflow, as:"    | tee -a error.log
echo "        uv run langflow run"    | tee -a error.log
echo "---------- "   | tee -a error.log
echo "  "   | tee -a error.log

sleep 9

# 2.1 Install Flowise as NORMAL user
echo " "
echo "Installing flowvise...Takes time..."  | tee -a error.log
echo "------"   | tee -a error.log
echo " "   | tee -a error.log
sleep 9
npm install -g flowise  2>> error.log
echo " "
echo " "     | tee -a ~/error.log
echo "flowise installed"    | tee -a ~/error.log
echo " "     | tee -a ~/error.log



# Download tinyllama
echo " "   | tee -a error.log
echo "--------- "   | tee -a error.log
echo "Downloading tinyllama for ollama"   | tee -a error.log
echo "Download size is 637MB"
echo "------"   | tee -a error.log
echo " "   | tee -a error.log
ollama pull tinyllama   2>> error.log
sleep 9

echo "  "     | tee -a ~/error.log
echo "  "     | tee -a ~/error.log
echo "tinyllama downloaded"     | tee -a ~/error.log
echo "Check as: ollama list"    | tee -a ~/error.log
echo "-------"   | tee -a ~/error.log

# Move script file to done folder
mv ~/script3.sh ~/done
mv ~/next/docker_install.sh  ~

echo " "
echo "Will shut down Ubuntu console"
echo "Reopen it and install docker, as:"
echo "  sudo ./docker_install.sh"
echo "----------"
echo " "
sleep 10
exit


