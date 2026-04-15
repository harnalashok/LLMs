#!/bin/bash

# Get list of local ai models
echo " "
echo "========"
echo "List of downloaded models"
echo "========"
echo " "
curl http://localhost:8080/v1/models
echo " "
echo " "
echo "Downloaded models are stored here:"
echo "       /var/lib/docker/volumes/12518350e14a619d6c5412073fec2a2988d41ea582780244d168c6d8ccef5229/_data/"
echo " "   
