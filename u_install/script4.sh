#!/bin/bash

# Last amended: 27th Jan, 2024
# These sscripts run in sequence.
      #     script0.sh
      #     script1.sh
      #     script2.sh
      #     docker_install.sh
      #     script3.sh
      #     script4.sh
      #     script5.sh
      #     script6.sh

cd ~/

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
echo "Call script5.sh after this is finished."
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



echo '#!/bin/bash'                                         | tee    /home/ashok/start/start_milvus.sh
echo " "                                                   | tee -a /home/ashok/start/start_milvus.sh
echo "cd ~/"                                               | tee -a /home/ashok/start/start_milvus.sh
echo "echo 'Ports are: 9091 and 19530.'"                   | tee -a /home/ashok/start/start_milvus.sh
echo "cd /home/ashok/milvus"                               | tee -a /home/ashok/start/start_milvus.sh
echo "bash standalone_embed.sh start"                      | tee -a /home/ashok/start/start_milvus.sh
echo "netstat -aunt | grep 9091"                           | tee -a /home/ashok/start/start_milvus.sh


echo '#!/bin/bash'                                         | tee -a /home/ashok/stop/stop_milvus.sh 
echo " "                                                   | tee -a /home/ashok/stop/stop_milvus.sh 
echo "cd ~/"                                               | tee -a /home/ashok/stop/stop_milvus.sh 
echo "cd /home/ashok/milvus"                               | tee -a /home/ashok/stop/stop_milvus.sh 
echo "bash standalone_embed.sh stop"                       | tee -a /home/ashok/stop/stop_milvus.sh 
echo "netstat -aunt | grep 9091"                           | tee -a /home/ashok/stop/stop_milvus.sh 


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



echo '#!/bin/bash'                                         >> /home/ashok/start/start_docker_flowise.sh
echo " "                                                   >> /home/ashok/start/start_docker_flowise.sh
echo "cd ~/"                                               >> /home/ashok/start/start_docker_flowise.sh
echo "echo 'Flowise port 3000 onstarting'"                 >> /home/ashok/start/start_docker_flowise.sh
echo "cd /home/ashok/Flowise"                              >> /home/ashok/starr/start_docker_flowise.sh
echo "docker start flowise"                                >> /home/ashok/start/start_docker_flowise.sh
echo "netstat -aunt | grep 3000"                           >> /home/ashok/start/start_docker_flowise.sh


echo '#!/bin/bash'                                        >> /home/ashok/stop/stop_docker_flowise.sh
echo " "                                                  >> /home/ashok/stop/stop_docker_flowise.sh
echo "cd ~/"                                              >> /home/ashok/stop/stop_docker_flowise.sh
echo "echo 'Flowise Stopping'"                            >> /home/ashok/stop/stop_docker_flowise.sh
echo "cd /home/ashok/Flowise"                             >> /home/ashok/stop/stop_docker_flowise.sh
echo "docker stop flowise"                                >> /home/ashok/stop/stop_docker_flowise.sh
echo "netstat -aunt | grep 3000"                           >> /home/ashok/stop/stop_docker_flowise.sh
sleep 4


# Ref: https://docs.langflow.org/Deployment/deployment-docker
echo "Installing langflow docker"                         | tee -a /home/ashok/info.log
cd /home/ashok/
git clone https://github.com/langflow-ai/langflow.git
cd langflow/docker_example
sudo docker-compose up -d
netstat -aunt | grep 7860

echo '#!/bin/bash'                                         >> /home/ashok/start/start_docker_langflow.sh
echo " "                                                   >> /home/ashok/start/start_docker_langflow.sh
echo "cd ~/"                                               >> /home/ashok/start/start_docker_langflow.sh
echo "echo 'langflow port 7860 onstarting'"                >> /home/ashok/start/start_docker_langflow.sh
echo "cd /home/ashok/langflow/docker_example"              >> /home/ashok/start/start_docker_langflow.sh
echo "docker-compose up -d"                                >> /home/ashok/start/start_docker_langflow.sh
echo "netstat -aunt | grep 7860"                           >> /home/ashok/start/start_docker_langflow.sh


echo '#!/bin/bash'                                        >> /home/ashok/stop/stop_docker_langflow.sh
echo " "                                                  >> /home/ashok/stop/stop_docker_langflow.sh
echo "cd ~/"                                              >> /home/ashok/stop/stop_docker_langflow.sh
echo "echo 'langflow will be stopped'"                    >> /home/ashok/stop/stop_docker_langflow.sh
echo "cd /home/ashok/langflow/docker_example"              >> /home/ashok/stop/stop_docker_langflow.sh
echo "docker-compose down"                                 >> /home/ashok/stop/stop_docker_langflow.sh
echo "netstat -aunt | grep 7860"                           >> /home/ashok/stop/stop_docker_langflow.sh


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


echo '#!/bin/bash'                                             >> /home/ashok/start/start_portainer.sh
echo " "                                                       >> /home/ashok/start/start_portainer.sh
echo "cd ~/"                                                   >> /home/ashok/start/start_portainer.sh
echo "echo '#========'"                                        >> /home/ashok/start/start_portainer.sh
echo "echo '#Access portainer at:'"                            >> /home/ashok/start/start_portainer.sh
echo "echo '#https://127.0.0.1:9443'"                          >> /home/ashok/start/start_portainer.sh
echo "echo '#User: admin; password: foreschoolmgt'"            >> /home/ashok/start/start_portainer.sh
echo "echo '#=========='"                                      >> /home/ashok/start/start_portainer.sh
echo "cd /home/ashok/portainer/"                               >> /home/ashok/start/start_portainer.sh
echo "docker start portainer"                                  >> /home/ashok/start/start_portainer.sh
echo "netstat -aunt | grep 9443"                               >> /home/ashok/start/start_portainer.sh

echo '#!/bin/bash'                                             >> /home/ashok/stop/stop_portainer.sh
echo " "                                                       >> /home/ashok/stop/stop_portainer.sh
echo "cd ~/"                                                   >> /home/ashok/stop/stop_portainer.sh
echo "cd /home/ashok/portainer/"                               >> /home/ashok/stop/stop_portainer.sh
echo "docker stop portainer"                                   >> /home/ashok/stop/stop_portainer.sh
echo "netstat -aunt | grep 9443"                               >> /home/ashok/stop/stop_portainer.sh



# Move script file to done folder
cd ~/
chmod +x *.sh
mv /home/ashok/script4.sh /home/ashok/done
mv /home/ashok/next/script5.sh  /home/ashok/


echo " "
echo "Reboot and then, install llama-cpp-python, as below."
echo "    ./script5.sh"
sleep 8
echo " "
reboot


