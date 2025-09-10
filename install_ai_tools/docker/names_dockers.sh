#!/bin/bash

echo Listing names of all docker containers

docker ps -a --format "{{.Names}}"
echo " "
echo "===="
docker ps -a --format "table {{.ID}}\t{{.Names}}"
echo "===="
echo " "
echo "Containers relating to RagFlow"
cd /home/$USER/
docker compose ps
echo " "
echo "====="


