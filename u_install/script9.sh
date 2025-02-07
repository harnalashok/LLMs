#!/bin/bash

 # These scripts run in sequence.
      #     script0.sh
      #     script1.sh
      #     script2.sh
      #     docker_install.sh
      #     script3.sh
      #     script4.sh
      #     script5.sh
      #     script6.sh
      #     script7.sh
      #     script8.sh
      #     script9.sh



echo "========script9=============="
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

mv /home/ashok/script9.sh  /home/ashok/done/

echo "You may like to execute:"
echo "       ./download_models.sh"
sleep 10
kill $PPID
