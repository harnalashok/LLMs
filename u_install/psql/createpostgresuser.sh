#!/bin/bash
 
echo " "
echo 'Ref: https://stackoverflow.com/a/2172588'
echo " "
echo "============"
echo 'Will open psql shell to create user, password and his database'
echo "============"
echo " "
echo 'Write below a user LOGIN password, mypass, within single inverted commas'
echo 'CREATE ROLE myuser LOGIN PASSWORD mypass ; '
echo 'CREATE DATABASE mydatabase WITH OWNER = myuser;'
echo 'To quit psql shell enter \q'
sleep 10
sudo -u postgres psql postgres
