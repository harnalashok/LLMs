#!/bin/bash


echo "Files docstore.json and faiss.index will be deleted"
echo "Press ctrl+c now to abort. Waiting for 8 seconds..."
sleep 8
rm /home/ashok/faiss/docstore.json
rm /home/ashok/faiss/faiss.index
echo "Done..."
