#!/bin/sh

# LAst amended: 17th Jan, 2025
# Ref: https://www.server-world.info/en/note?os=Ubuntu_22.04&p=llama&f=1


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




echo "========script5=============="
echo "Will install llama-cpp-python"
echo "Will prepare a sample start script for it"
echo "Will call no other script.sh"
echo "==========================="
sleep 10


echo " " | tee -a /home/ashok/error.log
echo "*********"  | tee -a /home/ashok/error.log
echo "Script: script5.sh"  | tee -a /home/ashok/error.log
echo "**********" | tee -a /home/ashok/error.log
echo " " | tee -a /home/ashok/error.log

# Install required packages:
echo "Installing dependencies " | tee -a /home/ashok/error.log
echo "*********"  | tee -a /home/ashok/error.log
sudo apt -y install python3-pip python3-dev python3-venv gcc g++ make jq
echo "Dependencies installed"  | tee -a /home/ashok/error.log
echo " " | tee -a /home/ashok/error.log
sleep 9

# Login as a common user and prepare Python virtual environment
#   to install [llama-cpp-python].
echo " "  | tee -a /home/ashok/error.log
echo "Installing llama-cpp-python " | tee -a /home/ashok/error.log
echo "*********"  | tee -a /home/ashok/error.log

# Remove any venv, if it exists:
rm -rf /home/ashok/llama
# Creating virtual environment
 python3 -m venv --system-site-packages /home/ashok/llama
 # Activating virtual envitronment
 source /home/ashok/llama/bin/activate
 # Install [llama-cpp-python].
 pip3 install llama-cpp-python[server]
 sleep 2
 deactivate
 echo " "  | tee -a /home/ashok/error.log
 echo "Installation of  llama-cpp-python done" | tee -a /home/ashok/error.log
 echo "*********"  | tee -a /home/ashok/error.log

 echo "Installation of  llama-cpp-python done" | tee -a /home/ashok/info.log
 echo "Activate virtual environment as: source /home/ashok/llama/bin/activate "   | tee -a /home/ashok/info.log
 echo "*********"  | tee -a /home/ashok/info.log
# llama-cpp-python template
echo "source /home/ashok/llama/bin/activate" > /home/ashok/llama_cpp_template.sh
echo "python3 -m llama_cpp.server --model /home/ashok/llama.cpp/models//llama-2-13b-chat.Q4_K_M.gguf --host 0.0.0.0 --port 8000 --chat functionary & " | tee -a /home/ashok/llama_cpp_template.sh
chmod +x *.sh
 sleep 9

# Move scripts
mv /home/ashok/script5.sh  /home/ashok/done/
mv /home/ashok/next/download_models.sh   /home/ashok/

echo "You may like to execute:"
echo "       ./download_models.sh"
sleep 10
kill $PPID


