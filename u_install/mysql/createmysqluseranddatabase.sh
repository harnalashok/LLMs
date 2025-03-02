#!/bin/bash

# Needed so that sudo password is not asked again
# sudo PAssword is also being supplied 
echo ashok | sudo -S pwd
echo " "
echo " "
echo "Execute the following four statements in mysql shell"
echo "to create a database, a user and then grant him"
echo "all privileges over the database."
echo "Change names as appropriate."
echo " "
echo "============"
echo "1."
echo "create database mydatabase ; "
echo "2."
echo "create user 'ravi'@'localhost' identified by 'ravipwd' ; "
echo "3."
echo "grant all privileges on mydatabase.* to 'ravi'@'localhost' ; "
echo "4."
echo "flush privileges; " 
echo "================"
echo " "
echo "Just press ENTER, as there is no password."
sleep 8
sudo -S mysql -u root -p
