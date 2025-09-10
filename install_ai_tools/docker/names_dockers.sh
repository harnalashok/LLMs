#!/bin/bash

echo Listing names of all docker containers
echo "==========="
echo " "
docker ps -a --format "{{.Names}}"
echo " "
echo "===="
docker ps -a --format "table {{.ID}}\t{{.Names}}"
echo "===="
echo " "
echo "Containers relating to RagFlow"
cd /home/$USER/ragflow/docker
docker compose ps -a --format "{{.Names}}"
echo " "
echo "====="
cd /home/$USER


