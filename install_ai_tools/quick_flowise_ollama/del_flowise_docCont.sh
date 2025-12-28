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
docker stop docker-flowise-1
 
