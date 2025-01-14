#!/bin/bash


# These sscripts run in sequence.
#     script0.sh
#     script1.sh
#     script2.sh
#     script3.sh
#     script4.sh
#     docker_install.sh
#     test.sh



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
echo "langflow installed"   | tee -a error.log
echo " "
sleep 9

# 2.1 Install Flowise as NORMAL user
echo " "
echo "Installing flowvise...Takes time..."  | tee -a error.log
echo "------"   | tee -a error.log
echo " "   | tee -a error.log
sleep 9
npm install -g flowise  2>> error.log
echo " "
echo "flowise installed"
echo " "



# Download tinyllama
echo " "   | tee -a error.log
echo "--------- "   | tee -a error.log
echo "Downloading tinyllama"   | tee -a error.log
echo "Download size is 637MB"
echo "------"   | tee -a error.log
echo " "   | tee -a error.log
ollama pull tinyllama   2>> error.log
sleep 2
echo "tinyllama downloaded"


# Move script file to done folder
mv /home/ashok/script3.sh /home/ashok/done
mv /home/ashok/next/docker_install.sh  /home/ashok

echo " "
echo "Will shut down Ubuntu console"
echo "Reopen it and install docker, as:"
echo "  sudo ./docker_install.sh"
echo "----------"
echo " "
sleep 10
wsl.exe --shutdown


