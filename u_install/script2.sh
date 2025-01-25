#!/bin/bash

# Last amended: 14th Jan, 2025


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




echo "========script2=============="
echo "Will install llama.cpp directly"
echo "Will install Node.js"
echo "Will call docker_install.sh as sudo user"
echo "==========================="
sleep 10


echo " "                                      | tee -a /home/ashok/error.log
echo "*********"                              | tee -a /home/ashok/error.log
echo "Script: script2.sh"                     | tee -a /home/ashok/error.log
echo "**********"                             | tee -a /home/ashok/error.log
echo " "                                      | tee -a /home/ashok/error.log



DIRECTORY="/home/ashok/llama.cpp"
if [ -d "$DIRECTORY" ]; then
  echo "$DIRECTORY does exist."
  echo "Recheck if script2.sh was executed earlier"
  echo "Press ctrl+c to terminate this job"
  sleep 40
fi


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




# 1.2 download and install Node.js
echo " "                                       | tee -a /home/ashok/error.log
echo "-------"                                 | tee -a /home/ashok/error.log
echo "Installing Node.js ver 20......"         | tee -a /home/ashok/error.log
echo "-------"                                 | tee -a /home/ashok/error.log
fnm use --install-if-missing 20                2>> /home/ashok/error.log
echo " "                                       | tee -a /home/ashok/error.log
echo "Node.js installed"                       | tee -a /home/ashok/error.log
echo "11. Node.js installed"                   | tee -a /home/ashok/error.log
echo "------------"                            | tee -a /home/ashok/error.log
echo "  "                                      | tee -a /home/ashok/error.log

sleep 2

# Move script file to done folder
mv /home/ashok/script2.sh /home/ashok/done
mv /home/ashok/next/docker_install.sh /home/ashok/

sudo bash docker_install.sh



#echo "  "
#echo "Will shut down Ubuntu console"
#echo "After shutdown, reopen ubuntu console and execute the command:"
#echo "    ./script3.sh"
#echo "----------"
#echo " "
#exec sleep 9
#exit


