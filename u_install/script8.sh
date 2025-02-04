#!/bin/bash

echo "========script7=============="
echo "Will create script to create postgresql user/database"  
echo "Needed for RecordManager"
echo "You may call download_models.sh to download gguf models or from ollama library"
echo "==========================="
sleep 10

# Create a script, that will inturn, help create user and password
# in postgresql

echo "#!/bin/bash"                                                                         > /home/ashok/createpostgresuser.sh
echo " "                                                                                  >>   /home/ashok/createpostgresuser.sh
echo "echo 'Ref: https://stackoverflow.com/a/2172588'"                                    >>   /home/ashok/createpostgresuser.sh
echo "echo 'Will open psql shell to create user, password and his database'"              >>   /home/ashok/createpostgresuser.sh
echo "echo 'Write below a user LOGIN password, mypass, within single inverted commas'"    >>   /home/ashok/createpostgresuser.sh
echo "echo 'CREATE ROLE myuser LOGIN PASSWORD mypass ; '"                                 >>   /home/ashok/createpostgresuser.sh
echo "echo 'CREATE DATABASE mydatabase WITH OWNER = myuser;'"                             >> /home/ashok/createpostgresuser.sh
echo "echo 'To quit psql shell enter \\q'"                                                >> /home/ashok/createpostgresuser.sh
echo "sleep 10"                                                                           >> /home/ashok/createpostgresuser.sh
# To open psql shell to enter DDL/DML commands
echo "sudo -u postgres psql postgres"                                                     >> /home/ashok/createpostgresuser.sh
chmod +x /home/ashok/*.sh



echo "You may like to execute:"
echo "       ./download_models.sh"
sleep 10
kill $PPID
