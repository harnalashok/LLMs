#!/bin/bash

echo "========script6=============="
echo "Will Install FAISS library"
echo "Will install redis-stack-server docker"
echo "==========================="
sleep 10


cd ~/

##########################
### Install FAISS library
##########################

echo "============"
echo "While using flowise, the 'Base Path to Load' which needs to be spcified"
echo "is of the folder where data files will be saved. Consider this as the "
echo "location of FAISS database for that application."
echo "=============="
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
echo "FAISS library installed"
sleep 4

##########################
### redis-stack-server docker install
##########################
# Ref: https://redis.io/docs/latest/operate/oss_and_stack/install/install-stack/docker/

mkdir /home/ashok/redis
docker run -d --name redis-stack-server -p 6379:6379 redis/redis-stack-server:latest

# redis start script
echo '#!/bin/bash'                                                                                             > /home/ashok/start/start_redis.sh
echo " "                                                                                                       >> /home/ashok/start/start_redis.sh
echo "echo 'Access redis server port 6379. Wait...starting...'"                                                >> /home/ashok/start/start_redis.sh
echo "echo 'To stop it, issue command: cd /home/ashok/redis/ ; docker stop redis-stack-server'"                 >> /home/ashok/start/start_redis.sh
echo "echo 'To connect to redis cli, after start, issue command: docker exec -it  redis-stack-server redis-cli'"   >> /home/ashok/start/start_redis.sh
echo "sleep 9"                                                                                                  >> /home/ashok/start/start_redis.sh
echo "cd /home/ashok/redis"                                                                                      >> /home/ashok/start/start_redis.sh
echo " docker start redis-stack-server"                                                                          >> /home/ashok/start/start_redis.sh
echo "netstat -aunt | grep 6379"                                                                                 >> /home/ashok/start/start_redis.sh


# redis stop script
echo '#!/bin/bash'                                                                                              > /home/ashok/stop/stop_redis.sh
echo "echo 'Stopping redis server'"                                                                             >> /home/ashok/stop/stop_redis.sh
echo "cd /home/ashok/redis"                                                                                      >> /home/ashok/stop/stop_redis.sh
echo " docker stop redis-stack-server"                                                                           >> /home/ashok/stop/stop_redis.sh
echo "netstat -aunt | grep 6379"                                                                                 >> /home/ashok/stop/stop_redis.sh
chmod +x /home/ashok/start/*.sh
chmod +x /home/ashok/stop/*.sh


# Move script file to done folder
mv /home/ashok/script6.sh /home/ashok/done
mv /home/ashok/next/script7.sh /home/ashok/

