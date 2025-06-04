#!/bin/bash

echo "Files 'docstore.json' and 'faiss.index' will be deleted"
echo "from folder /home/ashok/faiss"

while true; do

read -p "Do you want to proceed? (y/n) " yn

case $yn in 
	[yY] ) echo ok, we will proceed;
		break;;
	[nN] ) echo exiting...;
		exit;;
	* ) echo invalid response;;
esac

done

rm /home/ashok/faiss/docstore.json
rm /home/ashok/faiss/faiss.index
echo "Done...FAISS library has no data files.."




