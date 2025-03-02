#!/bin/bash

# LAst amended: 27th Jan, 2025
# Ref: https://www.server-world.info/en/note?os=Ubuntu_22.04&p=llama&f=1
# For examples of OPENAI usage, see:
#      # Ref: https://github.com/Jaimboh/Llama.cpp-Local-OpenAI-server/tree/main


echo "========script10=============="
echo "Will install llama-cpp-python"
echo "Will prepare a sample start script for it"
echo "Will install mongodb docker and mongosh shell"
echo "Will call no other script"
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

echo '#!/bin/bash'                                                                 >  /home/ashok/start/start_llama_cpp_python_server.sh
echo " "                                                                           >> /home/ashok/start/start_llama_cpp_python_server.sh
echo "echo 'Will start the server with model:'"                                   >> /home/ashok/start/start_llama_cpp_python_server.sh
echo "echo '       llama-2-13b-chat.Q4_K_M.gguf '"                                >> /home/ashok/start/start_llama_cpp_python_server.sh
echo "echo '       Model alias is: gpt-3.5-turbo  '"                              >> /home/ashok/start/start_llama_cpp_python_server.sh
echo "echo 'If the server fails as port 8000 is already busy'"                      >> /home/ashok/start/start_llama_cpp_python_server.sh
echo "echo 'then, issue following command to check which service is'"              >> /home/ashok/start/start_llama_cpp_python_server.sh
echo "echo 'listening on port 8000. And kill it.'"                                 >> /home/ashok/start/start_llama_cpp_python_server.sh
echo "echo 'sudo lsof -i:8000'"                                                    >> /home/ashok/start/start_llama_cpp_python_server.sh
echo "echo 'Kill, as:  sudo kill -9 PID1 PID2'"                                    >> /home/ashok/start/start_llama_cpp_python_server.sh
echo "cd ~/"                                                                       >> /home/ashok/start/start_llama_cpp_python_server.sh
echo "sleep 10 "                                                                   >> /home/ashok/start/start_llama_cpp_python_server.sh
echo "source /home/ashok/llama/bin/activate"                                       >> /home/ashok/start/start_llama_cpp_python_server.sh
echo "python -m llama_cpp.server --host 127.0.0.1 --model_alias gpt-3.5-turbo --model models/llama-2-13b-chat.Q4_K_M.gguf  --chat functionary" >> /home/ashok/start/start_llama_cpp_python_server.sh
chmod +x /home/ashok/start/*.sh

## B.
echo '#!/bin/bash'                                         >  /home/ashok/help_llama_cpp.sh
echo " "                                                   >> /home/ashok/help_llama_cpp.sh
echo "cd ~/"                                               >> /home/ashok/help_llama_cpp.sh
echo "source /home/ashok/llama/bin/activate"               >> /home/ashok/help_llama_cpp.sh
echo "python -m llama_cpp.server "                         >> /home/ashok/help_llama_cpp.sh
chmod +x /home/ashok/*.sh

## C.
# Write llama-cpp-python template
echo '#!/bin/bash'                                         | tee    /home/ashok/start/llama_cpp_python_template.sh
echo " "                                                   | tee -a /home/ashok/start/llama_cpp_python_template.sh
echo "echo 'Will start the server with model:'"            | tee -a /home/ashok/start/llama_cpp_python_template.sh
echo "echo '       llama-2-13b-chat.Q4_K_M.gguf '"         | tee -a /home/ashok/start/llama_cpp_python_template.sh
echo "cd ~/"                                               | tee -a /home/ashok/start/llama_cpp_python_template.sh
echo "source /home/ashok/llama/bin/activate"               | tee -a /home/ashok/start/llama_cpp_python_template.sh
echo "python3 -m llama_cpp.server --model /home/ashok/llama.cpp/models/llama-2-13b-chat.Q4_K_M.gguf --host 0.0.0.0 --port 8000 --chat functionary & " | tee -a /home/ashok/start/llama_cpp_python_template.sh

## D.
echo "echo 'Which service(s) is/are at port 8000?'"     > /home/ashok/start/pid_at_8000.sh
echo "echo 'Kill as: sudo kill -9 PID1  PID2'"       >> /home/ashok/start/pid_at_8000.sh
echo "sudo lsof -i:8000"                                >> /home/ashok/start/pid_at_8000.sh

chmod +x /home/ashok/start/*.sh
chmod +x *.sh
sleep 9

#############
## mongodb docker install
#############

# Install mongosh shell
# Ref: https://www.mongodb.com/docs/mongodb-shell/install/

wget -qO- https://www.mongodb.org/static/pgp/server-8.0.asc | sudo tee /etc/apt/trusted.gpg.d/server-8.0.asc

echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/8.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-8.0.list
sudo apt-get update
sudo apt-get install -y mongodb-mongosh

# Install images and then run the container
# https://www.mongodb.com/docs/manual/tutorial/install-mongodb-community-with-docker/#std-label-docker-mongodb-community-install
docker pull mongodb/mongodb-community-server:latest
docker run --name mongodb -p 27017:27017 -d mongodb/mongodb-community-server:latest
netstat -aunt | grep 27017
# mongosh --port 27017

echo '#!/bin/bash'                                         | tee    /home/ashok/start/start_mongodb.sh  
echo " "                                                   | tee -a /home/ashok/start/start_mongodb.sh  
echo "cd ~/"                                               | tee -a /home/ashok/start/start_mongodb.sh  
echo "echo 'mongodb will be available on port 27017'"      | tee -a /home/ashok/start/start_mongodb.sh  
echo "docker start mongodb"                                | tee -a /home/ashok/start/start_mongodb.sh  
echo "netstat -aunt | grep 27017"                          | tee -a /home/ashok/start/start_mongodb.sh  

echo '#!/bin/bash'                                         | tee    /home/ashok/stop/stop_mongodb.sh  
echo " "                                                   | tee -a /home/ashok/stop/stop_mongodb.sh  
echo "cd ~/"                                               | tee -a /home/ashok/stop/stop_mongodb.sh  
echo "echo 'mongodb will be stopped...wait'"               | tee -a /home/ashok/stop/stop_mongodb.sh  
echo "docker stop mongodb"                                 | tee -a /home/ashok/stop/stop_mongodb.sh  
echo "netstat -aunt | grep 27017"                          | tee -a /home/ashok/stop/stop_mongodb.sh  

# Create links
cd /home/ashok/start
ln -sT /home/ashok/start/start_mongodb.sh          /home/ashok/start_mongodb.sh  
cd /home/ashok/stop
ln -sT /home/ashok/stop/stop_mongodb.sh           /home/ashok/stop_mongodb.sh  
cd ~/
chmod +x *.sh
chmod +x /home/ashok/start/*.sh
chmod +x /home/ashok/stop/*.sh


#############
## mysql server install
#############
# https://documentation.ubuntu.com/server/how-to/databases/install-mysql/index.html
cd ~/
sudo apt install mysql-server -y
sudo service mysql status
sudo ss -tap | grep mysql

echo '#!/bin/bash'                                         | tee    /home/ashok/start/start_mysqlserver.sh  
echo " "                                                   | tee -a /home/ashok/start/start_mysqlserver.sh  
echo "cd ~/"                                               | tee -a /home/ashok/start/start_mysqlserver.sh   
echo "echo 'mysqlserver will be available on port 33060'"  | tee -a /home/ashok/start/start_mysqlserver.sh  
echo "sudo service mysql restart"                          | tee -a /home/ashok/start/start_mysqlserver.sh  
echo "netstat -aunt | grep 33060"                          | tee -a /home/ashok/start/start_mysqlserver.sh  

echo '#!/bin/bash'                                         | tee    /home/ashok/stop/stop_mysqlserver.sh  
echo " "                                                   | tee -a /home/ashok/stop/stop_mysqlserver.sh  
echo "cd ~/"                                               | tee -a /home/ashok/stop/stop_mysqlserver.sh  
echo "echo 'mysqlserver will be stopped'"                  | tee -a /home/ashok/stop/stop_mysqlserver.sh  
echo "sudo service mysql stop"                             | tee -a /home/ashok/stop/stop_mysqlserver.sh  
echo "netstat -aunt | grep 33060"                          | tee -a /home/ashok/stop/stop_mysqlserver.sh  

# Create links
cd /home/ashok/start
ln -sT  /home/ashok/start/start_mysqlserver.sh             /home/ashok/start_mysqlserver.sh    
cd /home/ashok/stop
ln -sT /home/ashok/stop/stop_mysqlserver.sh             /home/ashok/stop_mysqlserver.sh    
cd ~/
chmod +x *.sh
chmod +x /home/ashok/start/*.sh
chmod +x /home/ashok/stop/*.sh

# Install mysql shell
sudo apt-get install mysql-client

# Initialize Answer all questions as No, exept the last one
echo "Initialize: Answer all questions as No, exept the last one"
sleep 5
sudo mysql_secure_installation
sleep 2
clear


echo " "
echo "======="
echo "sudo mysql -u root -p "
echo "root has no password"
echo "===== "
echo " "


# Move scripts
mv /home/ashok/script10.sh        /home/ashok/done/


#echo "You may like to execute:"
#echo "       ./script7.sh"
sleep 10
kill $PPID


