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


echo " " | tee -a /home/ashok/error.log
echo "*********"  | tee -a /home/ashok/error.log
echo "Script: script6.sh"  | tee -a /home/ashok/error.log
echo "**********" | tee -a /home/ashok/error.log
echo " " | tee -a /home/ashok/error.log

#conda  deactivate

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

# Creating virtual environment
 python3 -m venv --system-site-packages /home/ashok/llama 
 # Activating virtual envitronment
 source /home/ashok/llama/bin/activate 
 # Install [llama-cpp-python]. 
 pip3 install llama-cpp-python[server] 
 echo " "  | tee -a /home/ashok/error.log
 echo "Installation of  llama-cpp-python done" | tee -a /home/ashok/error.log
 echo "*********"  | tee -a /home/ashok/error.log
 
 echo "Installation of  llama-cpp-python done" | tee -a /home/ashok/info.log
 echo "Activate virtual environment as: source /home/ashok/llama/bin/activate "   | tee -a /home/ashok/info.log
 echo "*********"  | tee -a /home/ashok/info.log
 sleep 9

# Move scripts
mv script6.sh  /home/ashok/done/
mv /home/ashok/next/script7.sh  /home/ashok/

 
# Downloading thellama-2-13b-chat.Q4_K_M.gguf format model.
# It's possible to download models from the following sitew.
# In this example, we will use [llama-2-13b-chat.Q4_K_M.gguf]. 
#  ⇒ https://huggingface.co/TheBloke/Llama-2-7B-chat-GGUF/tree/main
#  ⇒ https://huggingface.co/TheBloke/Llama-2-13B-chat-GGUF/tree/main
#  ⇒ https://huggingface.co/TheBloke/Llama-2-70B-Chat-GGUF/tree/main 

 echo " "  | tee -a /home/ashok/error.log
 echo "Downloading Llama-2-13B-chat-GGUF" | tee -a /home/ashok/error.log
 echo "Downloading size: 7.8GB" | tee -a /home/ashok/error.log
 echo "to folder /home/ashok/llama.cpp/models/"  | tee -a /home/ashok/error.log
 echo  "*********"  | tee -a /home/ashok/error.log
 cd  /home/ashok/llama.cpp/models/
 wget https://huggingface.co/TheBloke/Llama-2-13B-chat-GGUF/resolve/main/llama-2-13b-chat.Q4_K_M.gguf 
 sleep 2
 echo " "  | tee -a /home/ashok/error.log
 echo "Downloaded Llama-2-13B-chat-GGUF" | tee -a /home/ashok/error.log
 echo "Downloaded Llama-2-13B-chat-GGUF" | tee -a /home/ashok/info.log
 echo "Downloaded size: 7.8GB" | tee -a /home/ashok/info.log
 echo "Folder is /home/ashok/llama.cpp/models/"  | tee -a /home/ashok/info.log
 sleep 9
 
  
# Move script file to done folder
mv /home/ashok/script6.sh /home/ashok/done
mv /home/ashok/next/script7.sh /home/ashok/

echo "  "
echo "Will shut down Ubuntu console"
echo "----------"
echo " "
exec sleep 9
exit
