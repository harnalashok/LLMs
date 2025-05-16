#!/bin/bash

# LAst amended: 17th April, 2025
# Install process is same for Ubuntu machine and WSL ubuntu
# For WSL ubuntu there is need to edit /etc/neo4j/neo4j.conf file
# and uncomment line:  server.default_listen_address=0.0.0.0

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

# Install current Neo4j Community Edition:
sudo apt-get install neo4j
echo "Your version of neo4j is: (neo4j -V)"
neo4j -V

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


# neo4j start script:
echo '#!/bin/bash'                                         | tee    /home/ashok/start/start_neo4j.sh  
echo " "                                                   | tee -a /home/ashok/start/start_neo4j.sh  
echo "cd ~/"                                               | tee -a /home/ashok/start/start_neo4j.sh   
echo "echo 'neo4j will be available at port 7474'"         | tee -a /home/ashok/start/start_neo4j.sh  
echo "sudo systemctl start neo4j"                          | tee -a /home/ashok/start/start_neo4j.sh  
echo "echo 'Test as: netstat -aunt | grep 7474'"           | tee -a /home/ashok/start/start_neo4j.sh  
echo "echo 'Or re-run command: ./start_neo4j.sh'"          | tee -a /home/ashok/start/start_neo4j.sh  
echo "netstat -aunt | grep 7474"                           | tee -a /home/ashok/start/start_neo4j.sh  
echo "echo ''"                                             | tee -a /home/ashok/start/start_neo4j.sh  
echo "echo '==========='"                                  | tee -a /home/ashok/start/start_neo4j.sh  
echo "echo 'Access neo4j shell, as:'"                      | tee -a /home/ashok/start/start_neo4j.sh  
echo "echo '       cypher-shell -a '\''neo4j://127.0.0.1:7687'\'"     | tee -a /home/ashok/start/start_neo4j.sh  
echo "echo '       userid: neo4j, password: neo4j'"        | tee -a /home/ashok/start/start_neo4j.sh  
echo "echo ''"                                             | tee -a /home/ashok/start/start_neo4j.sh 
echo "echo 'Access neo4j in browser, as:'"                 | tee -a /home/ashok/start/start_neo4j.sh  
echo "echo '       localhost:7474'"                        | tee -a /home/ashok/start/start_neo4j.sh  
echo "echo '       userid: neo4j, password: neo4j'"        | tee -a /home/ashok/start/start_neo4j.sh  
echo "echo '==========='"                                  | tee -a /home/ashok/start/start_neo4j.sh 
echo "echo ''"                                             | tee -a /home/ashok/start/start_neo4j.sh 
echo "echo 'Note:'"                                        | tee -a /home/ashok/start/start_neo4j.sh 
echo "echo ' It is not possible to create a new database'"  | tee -a /home/ashok/start/start_neo4j.sh 
echo "echo ' in community edition. But you can change the'" | tee -a /home/ashok/start/start_neo4j.sh 
echo "echo ' name of default database, neo4j, by editing:'" | tee -a /home/ashok/start/start_neo4j.sh 
echo "echo ' file: /etc/neo4j/neo4j.conf '"                 | tee -a /home/ashok/start/start_neo4j.sh 
echo "echo ' Set the name of your default database, as'"    | tee -a /home/ashok/start/start_neo4j.sh 
echo "echo ' initial.dbms.default_database=school'"         | tee -a /home/ashok/start/start_neo4j.sh 
echo "echo ' Restart neo4j'"                                | tee -a /home/ashok/start/start_neo4j.sh 
echo "echo ''"                                             | tee -a /home/ashok/start/start_neo4j.sh 




# neo4j stop script
echo '#!/bin/bash'                                         | tee    /home/ashok/stop/stop_neo4j.sh  
echo " "                                                   | tee -a /home/ashok/stop/stop_neo4j.sh  
echo "cd ~/"                                               | tee -a /home/ashok/stop/stop_neo4j.sh  
echo "echo 'neo4j will be stopped'"                        | tee -a /home/ashok/stop/stop_neo4j.sh  
echo "sudo systemctl stop neo4j"                           | tee -a /home/ashok/stop/stop_neo4j.sh  
echo "echo 'Test as: netstat -aunt | grep 7474'"           | tee -a /home/ashok/stop/stop_neo4j.sh  

cd /home/ashok
ln -sT /home/ashok/stop/stop_neo4j.sh   stop_neo4j.sh  
ln -sT /home/ashok/start/start_neo4j.sh   start_neo4j.sh  
cd ~/

# PRemission changes
chmod +x /home/ashok/start/*.sh   
chmod +x /home/ashok/stop/*.sh



sleep 8



