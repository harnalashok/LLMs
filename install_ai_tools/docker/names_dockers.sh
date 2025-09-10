#!/bin/bash

echo Listing names of all docker containers

docker ps -a --format "{{.Names}}"
echo " "
echo "===="
docker ps -a --format "table {{.ID}}\t{{.Names}}"
echo "===="


