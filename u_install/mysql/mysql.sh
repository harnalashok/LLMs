#!/bin/bash

echo " "
echo "---------"
echo "Logging in as root user"
echo "First, you may be asked to supply 'sudo' password of ashok, supply it"
echo "Next, just a statement-- 'Enter Password' would appear. "
echo "Just press ENTER as 'root' has no password."
echo "----------"
echo " "
sleep 8
sudo mysql -u root -p
