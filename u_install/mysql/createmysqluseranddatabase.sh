#!/bin/bash


sudo cd ~/
echo " "
echo " "
echo "Execute the following three statements in mysql shell"
echo "to create a database, a user and to then grant him"
echo "all privileges over the database."
echo "Change names as appropriate."
echo " "
echo "============"
echo "create database mydatabase ; "
echo "create user 'ravi'@'localhost' identified by 'ravipwd' ; "
echo "grant all privileges on mydatabase.* to 'ravi'@'localhost' ; "
echo "================"
echo " "
echo " "
sleep 8
sudo mysql -u root -p
