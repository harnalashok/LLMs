#!/bin/bash

echo " "
echo "---------"
echo "Logging in as root user"
echo "When asked, supply 'sudo' password of ashok, supply it"
echo "But 'root' has no password. When asked, just press ENTER"
echo "----------"
echo " "
sleep 8
sudo mysql -u root -p
