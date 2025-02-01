#!/bin/bash

# LAst amended: 27th Jan, 2025
# Ref: https://www.server-world.info/en/note?os=Ubuntu_22.04&p=llama&f=1

# These sscripts run in sequence.
      #     script0.sh
      #     script1.sh
      #     script2.sh
      #     docker_install.sh
      #     script3.sh
      #     script4.sh
      #     script5.sh
      #     script6.sh

echo "========script5=============="
echo "Will install llama-cpp-python"
echo "Will prepare a sample start script for it"
echo "Will call no other script"
echo "You may call script6.sh"
echo "==========================="
sleep 10

cd ~/

echo " " | tee -a /home/ashok/error.log
echo "*********"  | tee -a /home/ashok/error.log
echo "Script: script5.sh"  | tee -a /home/ashok/error.log
echo "**********" | tee -a /home/ashok/error.log
echo " " | tee -a /home/ashok/error.log

# Install required packages:
#echo "Installing dependencies " | tee -a /home/ashok/error.log
#echo "*********"  | tee -a /home/ashok/error.log
#sudo apt -y install python3-pip python3-dev python3-venv gcc g++ make jq
#echo "Dependencies installed"  | tee -a /home/ashok/error.log
#echo " " | tee -a /home/ashok/error.log
#sleep 9

# Login as a common user and prepare Python virtual environment
#   to install [llama-cpp-python].
echo " "  | tee -a /home/ashok/error.log
echo "Installing llama-cpp-python " | tee -a /home/ashok/error.log
echo "*********"  | tee -a /home/ashok/error.log

# Remove any earlier venv at 'llama', if it exists:
rm -rf /home/ashok/llama

# Creat virtual environment at ~/llama folder:
 python3 -m venv --system-site-packages /home/ashok/llama

 # Activate virtual envitronment at 'llama'
 source /home/ashok/llama/bin/activate
 
 # Install [llama-cpp-python].
 pip3 install llama-cpp-python[server]
 sleep 2

 # Deactivate virtual envirobment
 deactivate
 
 echo " "  | tee -a /home/ashok/error.log
 echo "Installation of  llama-cpp-python done" | tee -a /home/ashok/error.log
 echo "*********"  | tee -a /home/ashok/error.log

 echo "Installation of  llama-cpp-python done" | tee -a /home/ashok/info.log
 echo "Activate virtual environment as: source /home/ashok/llama/bin/activate "   | tee -a /home/ashok/info.log
 echo "*********"  | tee -a /home/ashok/info.log
 

# Ref: https://github.com/Jaimboh/Llama.cpp-Local-OpenAI-server/tree/main

## A.
# Write llama-cpp-python server start sample
# Ref: https://github.com/Jaimboh/Llama.cpp-Local-OpenAI-server/tree/main

echo '#!/bin/bash'                                                                 >  /home/ashok/start/start_llama_cpp_server.sh
echo " "                                                                           >> /home/ashok/start/start_llama_cpp_server.sh
echo "echo 'Will start the server. with model:'"                                   >> /home/ashok/start/start_llama_cpp_server.sh
echo "echo '       llama-2-13b-chat.Q4_K_M.gguf '"                                 >> /home/ashok/start/start_llama_cpp_server.sh
echo "echo 'If the start fails if 8000 is already busy'"                           >>            ~/start/start_llama_cpp_server.sh
echo "echo 'then, issue following command to check which service is'"     >> ~/start/start_llama_cpp_server.sh
echo "echo 'listening on port 8000. And kill it.'"                        >> ~/start/start_llama_cpp_server.sh
echo "echo 'sudo lsof -i:8000'"                                           >> ~/start/start_llama_cpp_server.sh
echo "echo 'Kill, as:  sudo kill -9 PID1 PID2'"                           >> ~/start/start_llama_cpp_server.sh
echo "sleep 10 "                                                           >> ~/start/start_llama_cpp_server.sh
echo "python -m llama_cpp.server --host 127.0.0.1 --model_alias gpt-3.5-turbo --model models/llama-2-13b-chat.Q4_K_M.gguf  --chat functionary" >> ~/start/start_llama_cpp_server.sh

## B.
echo '#!/bin/bash'                                         >  /home/ashok/help_llama_cpp.sh
echo " "                                                   >> /home/ashok/help_llama_cpp.sh
echo "cd ~/"                                               >> /home/ashok/help_llama_cpp.sh
echo "source /home/ashok/llama/bin/activate"               >> /home/ashok/help_llama_cpp.sh
echo "python -m llama_cpp.server "                         >> /home/ashok/help_llama_cpp.sh
chmod +x /home/ashok/*.sh

## C.
# Write llama-cpp-python template
echo '#!/bin/bash'                                         | tee    /home/ashok/start/llama_cpp_template.sh
echo " "                                                   | tee -a /home/ashok/start/llama_cpp_template.sh
echo "cd ~/"                                               | tee -a /home/ashok/start/llama_cpp_template.sh
echo "source /home/ashok/llama/bin/activate"               | tee -a /home/ashok/start/llama_cpp_template.sh
echo "python3 -m llama_cpp.server --model /home/ashok/llama.cpp/models/llama-2-13b-chat.Q4_K_M.gguf --host 0.0.0.0 --port 8000 --chat functionary & " | tee -a /home/ashok/start/llama_cpp_template.sh

## D.
echo "echo 'Which service(s) is/are at port 8000?'"     > /home/ashok/start/pid_at_8000.sh
echo "echo 'Kill as: sudo kill -9 PID1  PID2'"       >> /home/ashok/start/pid_at_8000.sh
echo "sudo lsof -i:8000"                                >> /home/ashok/start/pid_at_8000.sh

chmod +x /home/ashok/start/*.sh
chmod +x *.sh
sleep 9

# Move scripts
mv /home/ashok/script5.sh  /home/ashok/done/
mv /home/ashok/next/script6.sh   /home/ashok/

echo "You may like to execute:"
echo "       ./script6.sh"
sleep 10
kill $PPID


