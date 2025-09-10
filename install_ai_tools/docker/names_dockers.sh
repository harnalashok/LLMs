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
echo "RagFlow Containers aloing with imageIDs"
docker compose images  | awk  '{print $1 "\t"  $5 "\t"  $2}'
cd /home/$USER


