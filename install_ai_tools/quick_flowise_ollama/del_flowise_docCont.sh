#!/usr/bin/bash

docker stop flowise
# Delete container
docker rm flowise
# Delete image
docker rmi flowise
# create .env file
cd /home/ashok/Flowise/docker
cp .env.example  .env
# Start docker
docker compose up -d
netstat -aunt | grep 3000
docker stop docker-flowise-1
sleep 2
sudo rm -rf /home/$USER/.flowise
sleep 2
docker start docker-flowise-1
sleep 2
netstat -aunt | grep 3000


# Create files
cd /home/$USER/
echo '#!/bin/bash'                                         >  /home/$USER/start_flowise.sh
echo " "                                                   >> /home/$USER/start_flowise.sh
echo "cd ~/"                                               >> /home/$USER/start_flowise.sh
echo "echo 'Flowise port 3000 onstarting'"                 >> /home/$USER/start_flowise.sh
echo "echo 'Access flowise as: http://localhost:3000'"           >> /home/$USER/start_flowise.sh
echo "cd /home/$USER/Flowise"                              >> /home/$USER/start_flowise.sh
echo "docker start docker-flowise-1"                       >> /home/$USER/start_flowise.sh
echo "sleep 3"                                             >> /home/$USER/start_flowise.sh
echo "netstat -aunt | grep 3000"                           >> /home/$USER/start_flowise.sh
# logs script
echo '#!/bin/bash'                                         >  /home/$USER/logs_flowise.sh
echo " "                                                   >> /home/$USER/logs_flowise.sh
echo "cd /home/$USER/"                                     >> /home/$USER/logs_flowise.sh
#echo "echo 'Flowise version is:'"                          >> /home/$USER/logs_flowise.sh
#echo "docker logs flowise | grep start:default | head -1 | awk '{print \$2}'"  >> /home/$USER/logs_flowise.sh
#echo "sleep 4"                                             >> /home/$USER/logs_flowise.sh
echo "docker logs docker-flowise-1"                         >> /home/$USER/logs_flowise.sh
# Stop script
echo '#!/bin/bash'                                        >  /home/$USER/stop_docker_flowise.sh
echo " "                                                  >> /home/$USER/stop_docker_flowise.sh
echo "cd /home/$USER/"                                    >> /home/$USER/stop_docker_flowise.sh
echo "echo 'Flowise Stopping'"                            >> /home/$USER/stop_docker_flowise.sh
echo "cd /home/$USER/Flowise"                             >> /home/$USER/stop_docker_flowise.sh
echo "docker stop docker-flowise-1"                                >> /home/$USER/stop_docker_flowise.sh
echo "netstat -aunt | grep 3000"                           >> /home/$USER/stop_docker_flowise.sh
