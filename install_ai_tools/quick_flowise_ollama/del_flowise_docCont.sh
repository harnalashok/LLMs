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
 
