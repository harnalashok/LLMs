#!/bin/bash

# LAst amended: 17th April, 2025
# Install process is same for Ubuntu machine and WSL ubuntu
# For WSL ubuntu there is need to edit /etc/neo4j/neo4j.conf file
# and uncomment 

# Ref: https://neo4j.com/docs/operations-manual/current/installation/linux/debian/#debian-installation

echo "Will install neo4j community edition"
echo "----------"
sleep 2
echo " "
echo " "
#  Add the Neo4j repository to the package manager
wget -O - https://debian.neo4j.com/neotechnology.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/neotechnology.gpg
echo 'deb [signed-by=/etc/apt/keyrings/neotechnology.gpg] https://debian.neo4j.com stable latest' | sudo tee -a /etc/apt/sources.list.d/neo4j.list
sudo apt-get update

# Once the repository has been added to apt, you can verify which Neo4j versions are available by running
apt list -a neo4j

# Install Neo4j Community Edition:
sudo apt-get install neo4j=1:2025.03.0 -y

echo " "
echo "neo4j Installation complete"
echo "-----------"
echo " "
# Default file locations:
echo "Default file locations:  https://neo4j.com/docs/operations-manual/current/configuration/file-locations/"
# Default ports
echo "Default ports: https://neo4j.com/docs/operations-manual/current/configuration/ports/"
echo "Start stop neo4j, as:"
echo "sudo systemctl start/stop neo4j"
echo " "
echo "============"
echo "Check if port 7687 is listening using netstat"
echo "Test  Neo4j connection with the command:"
echo " cypher-shell -a 'neo4j://127.0.0.1:7687' "
echo "Default database user: neo4j"
echo "Default database password: neo4j"
echo "============"
sleep 8



