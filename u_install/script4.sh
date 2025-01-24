#!/bin/bash

# Last amended: 14th Jan, 2024

# Connected scripts are:
# These sscripts run in sequence.
#     script0.sh
#     script1.sh
#     script2.sh
#     script3.sh
#     docker_install.sh
#     script4.sh
#     script5.sh
#     script5.sh
#     script7.sh


echo " "                                      | tee -a /home/ashok/error.log
echo "*********"                              | tee -a /home/ashok/error.log
echo "Script: script4.sh"                     | tee -a /home/ashok/error.log
echo "**********"                             | tee -a /home/ashok/error.log
echo " "                                      | tee -a /home/ashok/error.log


# Check if Docker installed
if docker -v  |  grep 'version'; then  
   echo " "
else
   echo "Docker engine is not installed. Install it first"   | tee -a /home/ashok/error.log
   sleep 10
   exit
fi


# Milvus install
# Ref: https://milvus.io/docs/install_standalone-docker.md

echo "Installing milvus vector database using docker"       | tee -a /home/ashok/error.log
echo "You will be asked for the password. Supply it..."     | tee -a /home/ashok/error.log

echo " "                                                    | tee -a /home/ashok/error.log
sleep 3

curl -sfL https://raw.githubusercontent.com/milvus-io/milvus/master/scripts/standalone_embed.sh -o standalone_embed.sh
bash standalone_embed.sh start  2>> /home/ashok/error.log

echo " "
echo "Milvus vector database installed"                      | tee -a /home/ashok/error.log
echo "Milvus vector database installed"                      | tee -a /home/ashok/info.log
echo "Ports used are: 9091 and 19530."                       | tee -a /home/ashok/info.log
echo "To stop docker use the following commands:"            | tee -a /home/ashok/info.log
echo "      ./standalone_embed.sh stop"                      | tee -a /home/ashok/info.log
echo "To delete the database, use the following command:"    | tee -a /home/ashok/info.log
echo "      ./standalone_embed.sh delete"                    | tee -a /home/ashok/info.log
echo "--------------------"                                  | tee -a /home/ashok/info.log

mkdir /home/ashok/milvus
mv standalone_embed.sh /home/ashok/milvus/
echo "PATH=$PATH:/home/ashok/milvus/" >> .bashrc

echo "Ports are: 9091 and 19530."       >> /home/ashok/start_milvus.sh
echo "cd /home/ashok/milvus"            >> /home/ashok/start_milvus.sh
echo "bash standalone_embed.sh start"   >> /home/ashok/start_milvus.sh

echo "Ports are: 9091 and 19530."       >> /home/ashok/stop_milvus.sh
echo "cd /home/ashok/milvus"            >> /home/ashok/stop_milvus.sh
echo "bash standalone_embed.sh stop"    >> /home/ashok/stop_milvus.sh

echo "cd /home/ashok/milvus"            >> /home/ashok/delete_milvus_db.sh
echo "bash standalone_embed.sh delete"  >> /home/ashok/delete_milvus_db.sh
sleep 3

# Install Flowise through docker"
# Ref: https://docs.flowiseai.com/getting-started
echo "Installing flowise docker"                          | tee -a /home/ashok/info.log
cd ~/
git clone https://github.com/FlowiseAI/Flowise.git
cd Flowise/
sudo docker build --no-cache -t flowise .
sudo docker run -d --name flowise -p 3000:3000 flowise
echo "In future to start/stop containers, proceed, as:"
echo "            cd /home/ashok/Flowise"                  | tee -a /home/ashok/info.log
echo "            docker start flowise"                    | tee -a /home/ashok/info.log
echo "            docker stop flowise"                     | tee -a /home/ashok/info.log
echo " Also, check all containers available, as:"
echo "             docker ps -a "                          | tee -a /home/ashok/info.log

echo "Flowise port 3000 onstarting"                       >> /home/ashok/start_flowise.sh
echo "cd /home/ashok/Flowise"                             >> /home/ashok/start_flowise.sh
echo "docker start flowise"                               >> /home/ashok/start_flowise.sh
echo "cd /home/ashok/Flowise"                             >> /home/ashok/stop_flowise.sh
echo "docker stop flowise"                                >> /home/ashok/stop_flowise.sh
sleep 4

# Ref: https://docs.langflow.org/Deployment/deployment-docker
echo "Installing langflow docker"                     | tee -a /home/ashok/info.log
cd /home/ashok/
git clone https://github.com/langflow-ai/langflow.git
cd langflow/docker_example
sudo docker-compose up
netstat -aunt | grep 7860

echo "langflow port 7860 onstarting"                       >> /home/ashok/start_langflow.sh
echo "cd /home/ashok/langflow/docker_example"              >> /home/ashok/start_langflow.sh
echo "docker-compose up"                                   >> /home/ashok/start_langflow.sh

echo "langflow port: 7860"                                 >> /home/ashok/stop_langflow.sh
echo "cd /home/ashok/langflow/docker_example"              >> /home/ashok/stop_langflow.sh
echo "docker-compose down"                                 >> /home/ashok/stop_langflow.sh


# Move script file to done folder
cd ~/
chmod +x *.sh
mv /home/ashok/script4.sh /home/ashok/done
mv /home/ashok/next/script7.sh  /home/ashok/

bash script7.sh


#echo " "
#echo "You can now test installation, as below."
#echo "Will shut down Ubuntu console, then open and execute:"
#echo "    ./script7.sh"
#exec sleep 8
#echo " "
#exit



