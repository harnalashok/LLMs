#!/bin/bash

echo Listing names of all docker containers

docker ps -a --format "{{.Names}}"


