#!/bin/bash

echo "========script6=============="
echo "Will Install FAISS library"
echo "Will install chromadb docker"
echo "Will install redis-stack-server docker"
echo "==========================="
sleep 10


cd ~/

##########################
### Install FAISS library
##########################

echo " "
echo "============"
echo "While using flowise, the 'Base Path to Load' which needs to be spcified"
echo "is of the folder where data files will be saved. Consider this as the "
echo "location of FAISS database for that application."
echo "=============="
echo " "
sleep 8
# Create venv for FAISS
python3 -m venv /home/ashok/faiss
source /home/ashok/faiss/bin/activate
pip3 install faiss-cpu
deactivate
## Script to activate FAISS library
echo '#!/bin/bash'                                                      > /home/ashok/start/activate_faiss.sh
echo " "                                                                >> /home/ashok/start/activate_faiss.sh
echo "cd ~/"                                                            >> /home/ashok/start/activate_faiss.sh
echo "echo 'Activate FAISS library, as:'"                                >> /home/ashok/start/activate_faiss.sh                             
echo "echo 'source /home/ashok/start/activate_faiss.sh'"                 >> /home/ashok/start/activate_faiss.sh
echo "echo 'To deactivate issue just the command: deactivate'"           >> /home/ashok/start/activate_faiss.sh
echo "source /home/ashok/faiss/bin/activate"                             >> /home/ashok/start/activate_faiss.sh
deactivate
echo "FAISS library installed at /home/ashok/faiss/"
echo "FAISS stores its data files 'docstore.json' and 'faiss.index' here."

# FAISS download data-cleaning script
cd /home/ashok/
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/u_install/faiss/empty_faiss_database.sh
chmod +x *.sh
sleep 4

cd ~/

##########################
### Install chromadb docker
##########################

echo "Shall I install chromadb docker? [Y,n]"    # Else docker chromadb may be installed
read input
if [[ $input == "Y" || $input == "y" ]]; then
    # Installing chromadb docker. 
    # Install chromadb
    echo " "                                       | tee -a /home/ashok/error.log
    echo " Will Install chromadb docker"                  | tee -a /home/ashok/error.log
    echo "------------"                            | tee -a /home/ashok/error.log
    echo " "                                       | tee -a /home/ashok/error.log
    sleep 3
    docker pull chromadb/chroma
    sleep 2
	
	# Chroma start script
    echo '#!/bin/bash'                                         | tee    /home/ashok/start/start_chroma.sh  
    echo " "                                                   | tee -a /home/ashok/start/start_chroma.sh  
    echo "cd ~/"                                               | tee -a /home/ashok/start/start_chroma.sh  
    echo "echo 'Chromadb will be available at port 8000'"      | tee -a /home/ashok/start/start_chroma.sh 
    echo "echo 'Data dir is ~/chroma-data/'"                 | tee -a /home/ashok/start/start_chroma.sh 
	   echo "docker run -v ./chroma-data:/data -p 8000:8000 chromadb/chroma"  | tee -a /home/ashok/start/start_chroma.sh 
    echo "sleep 5"                                             | tee -a /home/ashok/start/start_chroma.sh  
else
        echo "Skipping install of chromadb docker"
fi   

chmod +x /home/ashok/start/*.sh

cd /home/ashok


##########################
### redis-stack-server docker install
##########################
# Ref: https://redis.io/docs/latest/operate/oss_and_stack/install/install-stack/docker/

mkdir /home/ashok/redis
echo "This also mounts $HOME/redis/ as data volume to save data"
# Mount /home/ashok/redis as /data
docker run -d --name redis-stack-server -v /home/ashok/redis:/data -p 6379:6379 redis/redis-stack-server:latest

# redis start script
echo '#!/bin/bash'                                                                                             > /home/ashok/start/start_redis.sh
echo " "                                                                                                       >> /home/ashok/start/start_redis.sh
echo "echo 'Access redis server at port 6379. Wait...starting...'"                                           >> /home/ashok/start/start_redis.sh
echo "echo '1. To stop docker, issue command: docker stop redis-stack-server'"                               >> /home/ashok/start/start_redis.sh
echo "echo '2. To connect to redis cli, issue command: docker exec -it  redis-stack-server redis-cli'"        >> /home/ashok/start/start_redis.sh
echo "echo '      In the redis-cli, issue command: SAVE. This will dump memory to folder: $HOME/redis/'"      >> /home/ashok/start/start_redis.sh
echo "echo '3. Interact with the docker OS, as:  docker exec -it   containerID  ls -la /'"                     >> /home/ashok/start/start_redis.sh
echo "sleep 9"                                                                                                  >> /home/ashok/start/start_redis.sh
echo "cd /home/ashok/redis"                                                                                     >> /home/ashok/start/start_redis.sh
echo " docker start redis-stack-server"                                                                         >> /home/ashok/start/start_redis.sh
echo "netstat -aunt | grep 6379"                                                                                >> /home/ashok/start/start_redis.sh


# redis stop script
echo '#!/bin/bash'                                                                                              > /home/ashok/stop/stop_redis.sh
echo "echo 'Stopping redis server'"                                                                             >> /home/ashok/stop/stop_redis.sh
echo "cd /home/ashok/redis"                                                                                      >> /home/ashok/stop/stop_redis.sh
echo " docker stop redis-stack-server"                                                                           >> /home/ashok/stop/stop_redis.sh
echo "netstat -aunt | grep 6379"                                                                                 >> /home/ashok/stop/stop_redis.sh

# Download neo4j install script
echo "Downloading neo4j install script"
cd /home/ashok
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/u_install/neo4jInstall.sh

chmod +x /home/ashok/*.sh
chmod +x /home/ashok/start/*.sh
chmod +x /home/ashok/stop/*.sh



# Move script file to done folder
mv /home/ashok/script6.sh /home/ashok/done
mv /home/ashok/next/script7.sh /home/ashok/

