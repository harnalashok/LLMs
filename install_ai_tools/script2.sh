#!/bin/bash

# Last amended: 14th June, 2025

echo "========script2=============="
echo "Will install llama.cpp directly"
echo "Will install Node.js"
echo "   What is Node.js--See the end of this file"
echo "Install github-desktop"
echo "Call ubuntu_docker1.sh as sudo user"
echo "==========================="
sleep 10

cd ~/

echo " "                                      | tee -a /home/$USER/error.log
echo "*********"                              | tee -a /home/$USER/error.log
echo "Script: script2.sh"                     | tee -a /home/$USER/error.log
echo "**********"                             | tee -a /home/$USER/error.log
echo " "                                      | tee -a /home/$USER/error.log

# Check if llama.cpp is already installed?

DIRECTORY="/home/$USER/llama.cpp"
if [ -d "$DIRECTORY" ]; then
  echo "$DIRECTORY does exist."
  echo "Recheck if script2.sh was executed earlier"
  echo "Press ctrl+c to terminate this job"
  sleep 40
fi

###################
# llama.cpp install
###################

echo "Shall I install llama.cpp (Can be safely skipped)? [Y,n]"    # Else docker chromadb may be installed
read input
if [[ $input == "Y" || $input == "y" ]]; then
  # Installing llama.cpp
  echo " "                                         | tee -a /home/$USER/error.log
  echo "Installing llama.cpp"                      | tee -a /home/$USER/error.log
  echo "------------"                              | tee -a /home/$USER/error.log
  echo " "                                         | tee -a /home/$USER/error.log
  git clone https://github.com/ggerganov/llama.cpp
  cd llama.cpp
  cmake -B build
  cmake --build build --config Release
  cd ~
  sleep 2
  # Create a symlink to models and to gguf folder
  ln -s /home/$USER/llama.cpp/models/ /home/$USER/
  ln -s /home/$USER/llama.cpp/models/ /home/$USER/gguf
  
  echo "PATH=\$PATH:/home/$USER/llama.cpp/build/bin" >> .bashrc
  echo " "                                        | tee -a /home/$USER/error.log
  echo "-------"                                  | tee -a /home/$USER/error.log
  echo "llama.cpp installed"                      | tee -a /home/$USER/error.log
  echo "10. llama.cpp installed"                  | tee -a /home/$USER/info.log
  echo "-------"                                  | tee -a /home/$USER/error.log
  
  
  # Script to start llama.cpp server
  echo '#!/bin/bash'                                         | tee    /home/$USER/start/start_llamacpp_server.sh
  echo " "                                                   | tee -a /home/$USER/start/start_llamacpp_server.sh
  echo "cd ~/"                                               | tee -a /home/$USER/start/start_llamacpp_server.sh
  echo " "                                                   | tee -a /home/$USER/start/start_llamacpp_server.sh
  echo "echo 'llama.cpp server will be available at port: 8080'"            | tee -a /home/$USER/start/start_llamacpp_server.sh
  echo "echo 'Script will use model: llama-thinker-3b-preview-q8_0.gguf'"   | tee -a /home/$USER/start/start_llamacpp_server.sh
  echo "echo 'Change it, if you like, by changing the script'"              | tee -a /home/$USER/start/start_llamacpp_server.sh
  echo " "                                                                  | tee -a /home/$USER/start/start_llamacpp_server.sh
  echo "sleep 10"                                                           | tee -a /home/$USER/start/start_llamacpp_server.sh
  echo "llama-server -m ~/gguf/llama-thinker-3b-preview-q8_0.gguf -c 2048"  | tee -a /home/$USER/start/start_llamacpp_server.sh
else
  echo "Skipping install of llama.cpp"
fi
  
chmod +x /home/$USER/start/*.sh

##########
# Using gguf model by Ollama
#########

## Modelfile
# Create a sample Modelfile to transform a gguf models for use in Ollama:
# You can then issue the command to use a gguf model within ollama:
# See file help.txt for more details.

echo "FROM ~/gguf/llama-2-13b-chat.Q4_K_M.gguf"  > /home/$USER/Modelfile

#  ollama create <YourModelName> -f /home/$USER/Modelfile
# Note ollama blobs are stored at:  /usr/share/ollama/.ollama/models/blobs/

#################
# Install Node.js
#################

# 1.2 download and install Node.js

echo " "                                       | tee -a /home/$USER/error.log
echo "-------"                                 | tee -a /home/$USER/error.log
echo "Installing Node.js ver 20......"         | tee -a /home/$USER/error.log
echo "-------"                                 | tee -a /home/$USER/error.log
fnm use --install-if-missing 20                2>> /home/$USER/error.log
echo " "                                       | tee -a /home/$USER/error.log
echo "Node.js installed"                       | tee -a /home/$USER/error.log
echo "11. Node.js installed"                   | tee -a /home/$USER/error.log
node -v
echo "------------"                            | tee -a /home/$USER/error.log
echo "  "                                      | tee -a /home/$USER/error.log

# Refer https://github.com/Schniz/fnm#shell-setup
echo " "                                            >>  /home/$USER/.bashrc
echo 'eval "$(fnm env --use-on-cd --shell bash)"'   >>  /home/$USER/.bashrc
echo " "                                            >>  /home/$USER/.bashrc
sleep 6

# Move script file to done folder
mv /home/$USER/script2.sh /home/$USER/done
mv /home/$USER/next/ubuntu_docker1.sh /home/$USER/

# Add start/stop folders to PATH in .bashrc
echo "PATH=\$PATH:/home/$USER/start:/home/$USER/stop"  >> /home/$USER/.bashrc


###############
# github-desktop install
# May not work in WSL2 systems
# Ref: https://github.com/shiftkey/desktop?tab=readme-ov-file#installation-via-package-manager
###############

echo "Installing github-desktop. Maynot work in WSL2 systems...."
sleep 3

wget -qO - https://mirror.mwt.me/shiftkey-desktop/gpgkey | gpg --dearmor | sudo tee /usr/share/keyrings/mwt-desktop.gpg > /dev/null
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/mwt-desktop.gpg] https://mirror.mwt.me/shiftkey-desktop/deb/ any main" > /etc/apt/sources.list.d/mwt-desktop.list'

sudo apt update && sudo apt install github-desktop -y

echo "github-desktop installed"
sleep 4



# sudo bash ubuntu_docker.sh



#echo "  "
#echo "Shut down/reboot Ubuntu"
#echo "After shutdown, reopen ubuntu console and execute the command:"
#echo " sudo   ./ubuntu_docker1.sh"
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



