#!/bin/bash

echo " "
echo "---------"
echo "Logging in as root user"
echo "When asked, supply 'sudo' password of ashok"
echo "But 'root' has no password. When asked, press ENTER"
echo "----------"
echo " "
sudo mysql -u root -p
