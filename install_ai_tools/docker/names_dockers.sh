#!/bin/bash

clear
echo " "
cd /home/$USER
echo Listing names of all docker containers
echo "==========="
echo "  "
docker ps -a --format "{{.Names}}"
echo "  "
echo "===="
docker ps -a --format "table {{.ID}}\t{{.Names}}"
echo "===="
echo " "
echo "Containers relating to RagFlow"
echo "===="
echo " "
cd /home/$USER/ragflow/docker
docker compose ps -a --format "{{.Names}}"
echo " "
echo "====="
echo " "
echo "RagFlow Containers aloing with imageIDs"
echo " "
docker compose images  | awk  '{print $1 "\t"  $5 "\t"  $2}'
cd /home/$USER
echo "You can delete containers (by first stopping ragflow), as:"
echo "docker rm <container_name or container_id"
echo "Delete images as:"
echo "docker rmi <imageID"



