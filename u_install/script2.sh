#!/bin/bash

# Last amended: 14th Jan, 2025

 # These scripts run in sequence.
      #     script0.sh
      #     script1.sh
      #     script2.sh
      #     docker_install.sh
      #     script3.sh
      #     script4.sh
      #     script5.sh
      #     script6.sh
      #     script7.sh
      #     script8.sh



echo "========script2=============="
echo "Will install llama.cpp directly"
echo "Will install Node.js"
echo "   What is Node.js--See the end of this file"
echo "Call docker_install.sh as sudo user"
echo "==========================="
sleep 10

cd ~/

echo " "                                      | tee -a /home/ashok/error.log
echo "*********"                              | tee -a /home/ashok/error.log
echo "Script: script2.sh"                     | tee -a /home/ashok/error.log
echo "**********"                             | tee -a /home/ashok/error.log
echo " "                                      | tee -a /home/ashok/error.log

# Check if llama.cpp is already installed?

DIRECTORY="/home/ashok/llama.cpp"
if [ -d "$DIRECTORY" ]; then
  echo "$DIRECTORY does exist."
  echo "Recheck if script2.sh was executed earlier"
  echo "Press ctrl+c to terminate this job"
  sleep 40
fi

###################
# llama.cpp install
###################

# Installing llama.cpp
echo " "                                         | tee -a /home/ashok/error.log
echo "Installing llama.cpp"                      | tee -a /home/ashok/error.log
echo "------------"                              | tee -a /home/ashok/error.log
echo " "                                         | tee -a /home/ashok/error.log
git clone https://github.com/ggerganov/llama.cpp
cd llama.cpp
cmake -B build
cmake --build build --config Release
cd ~
sleep 2
# Create a symlink to models and to gguf folder
ln -s /home/ashok/llama.cpp/models/ /home/ashok/
ln -s /home/ashok/llama.cpp/models/ /home/ashok/gguf

echo "PATH=\$PATH:/home/ashok/llama.cpp/build/bin" >> .bashrc
echo " "                                        | tee -a /home/ashok/error.log
echo "-------"                                  | tee -a /home/ashok/error.log
echo "llama.cpp installed"                      | tee -a /home/ashok/error.log
echo "10. llama.cpp installed"                  | tee -a /home/ashok/info.log
echo "-------"                                  | tee -a /home/ashok/error.log


# Script to start llama.cpp server
echo '#!/bin/bash'                                         | tee    /home/ashok/start/start_llamacpp_server.sh
echo " "                                                   | tee -a /home/ashok/start/start_llamacpp_server.sh
echo "cd ~/"                                               | tee -a /home/ashok/start/start_llamacpp_server.sh
echo " "                                                   | tee -a /home/ashok/start/start_llamacpp_server.sh
echo "echo 'llama.cpp server will be available at port: 8080'"            | tee -a /home/ashok/start/start_llamacpp_server.sh
echo "echo 'Script will use model: llama-thinker-3b-preview-q8_0.gguf'"   | tee -a /home/ashok/start/start_llamacpp_server.sh
echo "echo 'Change it, if you like, by changing the script'"              | tee -a /home/ashok/start/start_llamacpp_server.sh
echo " "                                                                  | tee -a /home/ashok/start/start_llamacpp_server.sh
echo "sleep 10"                                                           | tee -a /home/ashok/start/start_llamacpp_server.sh
echo "llama-server -m ~/gguf/llama-thinker-3b-preview-q8_0.gguf -c 2048"  | tee -a /home/ashok/start/start_llamacpp_server.sh
chmod +x /home/ashok/start/*.sh

##########
# Using gguf model by Ollama
#########

## Modelfile
# Create a sample Modelfile to transform a gguf models for use in Ollama:
# You can then issue the command to use a gguf model within ollama:
# See file help.txt for more details.

echo "FROM ~/gguf/llama-2-13b-chat.Q4_K_M.gguf"  > /home/ashok/Modelfile

#  ollama create <YourModelName> -f /home/ashok/Modelfile
# Note ollama blobs are stored at:  /usr/share/ollama/.ollama/models/blobs/

#################
# Install Node.js
#################

# 1.2 download and install Node.js

echo " "                                       | tee -a /home/ashok/error.log
echo "-------"                                 | tee -a /home/ashok/error.log
echo "Installing Node.js ver 20......"         | tee -a /home/ashok/error.log
echo "-------"                                 | tee -a /home/ashok/error.log
fnm use --install-if-missing 20                2>> /home/ashok/error.log
echo " "                                       | tee -a /home/ashok/error.log
echo "Node.js installed"                       | tee -a /home/ashok/error.log
echo "11. Node.js installed"                   | tee -a /home/ashok/error.log
node -v
echo "------------"                            | tee -a /home/ashok/error.log
echo "  "                                      | tee -a /home/ashok/error.log

# Refer https://github.com/Schniz/fnm#shell-setup
echo 'eval "$(fnm env --use-on-cd --shell bash)"'   >> /home/ashok/.bashrc
sleep 6

# Move script file to done folder
mv /home/ashok/script2.sh /home/ashok/done
mv /home/ashok/next/docker_install.sh /home/ashok/

# Add start/stop folders to PATH in .bashrc
echo "PATH=\$PATH:/home/ashok/start;/home/ashok/stop"  >> /home/ashok/.bashrc



# sudo bash docker_install.sh



#echo "  "
#echo "Shut down/reboot Ubuntu"
#echo "After shutdown, reopen ubuntu console and execute the command:"
#echo " sudo   ./docker_install.sh"
#echo "----------"
#echo " "
#exec sleep 9
#exit

<< ////
What is Node.js and npm
=======================
Node.js is a powerful and efficient open-source runtime environment built on
Chrome's V8 JavaScript engine. It allows developers to run JavaScript on the 
server side, which helps in the creation of scalable and high-performance 
web applications.
NPM, or Node Package Manager, is a free, open-source registry and tool for 
managing JavaScript packages. It's the default package manager for Node.js

What does NPM do?

    Store packages: NPM is a repository for storing and sharing open-source JavaScript packages. 
    Install packages: NPM has a command-line interface (CLI) that lets you install packages from the registry. 
    Manage packages: NPM helps you manage package versions and dependencies. 
    Collaborate: NPM lets you create organizations to share packages privately or publicly. 
    
 << ////



