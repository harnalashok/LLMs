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

sleep 3


git clone https://github.com/FlowiseAI/Flowise.git
cd Flowise/
docker build --no-cache -t flowise .
docker run -d --name flowise -p 3000:3000 flowise


# Move script file to done folder
mv /home/ashok/script4.sh /home/ashok/done
mv /home/ashok/next/script5.sh  /home/ashok/

bash script5.sh


#echo " "
#echo "You can now test installation, as below."
#echo "Will shut down Ubuntu console, then open and execute:"
#echo "    ./script5.sh"
#exec sleep 8
#echo " "
#exit



