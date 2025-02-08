#!/bin/bash

# Ref: https://localai.io/models/

echo " "
echo "Download status to localai repo, only if download is in progress."
echo "Else, status may give error message"
echo " "

curl http://localhost:8080/models/jobs/

echo " "
