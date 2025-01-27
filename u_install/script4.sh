#!/bin/bash

# Last amended: 14th Jan, 2024

 # These sscripts run in sequence.
      #     script0.sh
      #     script1.sh
      #     script2.sh
      #     docker_install.sh
      #     script3.sh
      #     script4.sh
      #     script5.sh


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



echo "========script4=============="
echo "Will install Milvus vectordb docker"
echo "Will install Flowise docker"
echo "Will install langflow docker"
echo "Will install portainer docker"
echo "Will prepare start script for each"
echo "Will call script5.sh"
echo "==========================="
sleep 10


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

echo "echo 'Ports are: 9091 and 19530.'"       >> /home/ashok/start_milvus.sh
echo "cd /home/ashok/milvus"                   >> /home/ashok/start_milvus.sh
echo "bash standalone_embed.sh start"          >> /home/ashok/start_milvus.sh

echo "echo 'Ports are: 9091 and 19530.'"       >> /home/ashok/stop_milvus.sh
echo "cd /home/ashok/milvus"                   >> /home/ashok/stop_milvus.sh
echo "bash standalone_embed.sh stop"           >> /home/ashok/stop_milvus.sh

echo "cd /home/ashok/milvus"                   >> /home/ashok/delete_milvus_db.sh
echo "bash standalone_embed.sh delete"         >> /home/ashok/delete_milvus_db.sh
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

echo "echo 'Flowise port 3000 onstarting'"                >> /home/ashok/start_flowise.sh
echo "cd /home/ashok/Flowise"                             >> /home/ashok/start_flowise.sh
echo "docker start flowise"                               >> /home/ashok/start_flowise.sh
echo "cd /home/ashok/Flowise"                             >> /home/ashok/stop_flowise.sh
echo "docker stop flowise"                                >> /home/ashok/stop_flowise.sh
sleep 4



# Ref: https://docs.langflow.org/Deployment/deployment-docker
echo "Installing langflow docker"                         | tee -a /home/ashok/info.log
cd /home/ashok/
git clone https://github.com/langflow-ai/langflow.git
cd langflow/docker_example
sudo docker-compose up -d
netstat -aunt | grep 7860

echo "echo 'langflow port 7860 onstarting'"                >> /home/ashok/start_langflow.sh
echo "cd /home/ashok/langflow/docker_example"              >> /home/ashok/start_langflow.sh
echo "docker-compose up -d"                                >> /home/ashok/start_langflow.sh

echo "echo 'langflow port: 7860'"                          >> /home/ashok/stop_langflow.sh
echo "cd /home/ashok/langflow/docker_example"              >> /home/ashok/stop_langflow.sh
echo "docker-compose down"                                 >> /home/ashok/stop_langflow.sh

# Installing portrainer
echo "Installinh portrainer docker in directory portrainer"  | tee -a /home/ashok/info.log
cd ~/
mkdir /home/ashok/portainer
cd /home/ashok/portainer/
sudo docker volume create portainer_data
# This is one long line command
sudo docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:2.21.5
cd ~/
# Script to start portainer container
echo "cd /home/ashok/portainer/"                        >> /home/ashok/start_portainer.sh
echo "docker start portainer"                           >> /home/ashok/start_portainer.sh


# Move script file to done folder
cd ~/
chmod +x *.sh
mv /home/ashok/script4.sh /home/ashok/done
mv /home/ashok/next/script5.sh  /home/ashok/

#bash script5.sh
reboot


#echo " "
#echo "You can now test installation, as below."
#echo "Will shut down Ubuntu console, then open and execute:"
#echo "    ./script5.sh"
#exec sleep 8
#echo " "
#exit



