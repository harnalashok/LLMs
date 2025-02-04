#!/bin/bash

echo "========script7=============="
echo "Will install postgresql"
echo "You may call download_models.sh to download gguf models or from ollama library"
echo "==========================="
sleep 10

# Create a script, that will inturn, help create user and password
# in postgresql

echo "#!/bin/bash"  > /home/ashok/createpostgresuser.sh
echo " "   >>   /home/ashok/createpostgresuser.sh
echo "echo 'Ref: https://stackoverflow.com/a/2172588'" >>   /home/ashok/createpostgresuser.sh

#sudo apt install postgresql postgresql-contrib -y
#sudo systemctl start postgresql.service

echo "echo 'Write password, mypass, below within a single inverted comma'"  >>   /home/ashok/createpostgresuser.sh
echo "echo 'CREATE ROLE myuser LOGIN PASSWORD mypass ; '"  >>   /home/ashok/createpostgresuser.sh
echo "echo 'CREATE DATABASE mydatabase WITH OWNER = myuser;'"   >> /home/ashok/createpostgresuser.sh
echo "echo 'Quit psql shell with \\q'"   >> /home/ashok/createpostgresuser.sh

echo "sleep 10"  >> /home/ashok/createpostgresuser.sh
echo "sudo -u postgres psql postgres"  >> /home/ashok/createpostgresuser.sh


# sudo -u postgres createuser --interactive
#sudo -u postgres createuser  -P 'elitebabloo'



echo "You may like to execute:"
echo "       ./script7.sh"
sleep 10
kill $PPID
