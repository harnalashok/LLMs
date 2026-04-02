#!/bin/bash

# Last amended: 13th March, 2026

echo "   "
echo "    "
echo "Starting services"
echo "==========="
echo "   "
echo "    "

# Start software
bash start_ollama.sh
bash start_postgresql.sh
bash start_n8n.sh
bash start_flowise.sh
bash start_milvus.sh
bash start_meilisearch.sh 
echo "=============="
echo "  "
echo "   "
# Test n8n

#######3
abc=
abc=`sudo ss -tulpn | grep ':5678'`

if [[ -n $abc ]]; then
  echo "1. n8n is started."  > /home/$USER/Desktop/tested.txt
else
   echo "1. n8n NOT installed"  > /home/$USER/Desktop/tested.txt
fi

#######3
# Test ollama
abc=
abc=`sudo ss -tulpn | grep ':11434'`

if [[ -n $abc ]]; then
  echo "2. ollama is started."    >> /home/$USER/Desktop/tested.txt
else
   echo "2. ollama NOT installed"  >> /home/$USER/Desktop/tested.txt
fi

#######3
# Test postgres

abc=
abc=`sudo ss -tulpn | grep ':5432'`

if [[ -n $abc ]]; then
  echo "3. postgres is started."    >> /home/$USER/Desktop/tested.txt
else
   echo "3. postgres NOT installed"    >> /home/$USER/Desktop/tested.txt
fi

#######3
abc=
abc=`sudo ss -tulpn | grep ':19530'`

if [[ -n $abc ]]; then
  echo "4. milvus is started."     >> /home/$USER/Desktop/tested.txt
else
   echo "4. milvus NOT installed"    >> /home/$USER/Desktop/tested.txt
fi

#######3

abc=
abc=`sudo ss -tulpn | grep ':7700'`

if [[ -n $abc ]]; then
  echo "5. meilisearch is started."     >> /home/$USER/Desktop/tested.txt
else
   echo "5. meilisearch NOT installed"   >> /home/$USER/Desktop/tested.txt
fi

###########

abc=
abc=`sudo ss -tulpn | grep ':3000'`

if [[ -n $abc ]]; then
  echo "6. flowise is started."     >> /home/$USER/Desktop/tested.txt
else
   echo "6. flowise NOT installed"    >> /home/$USER/Desktop/tested.txt
fi

###########


abc=
abc=`nvidia-smi | grep 'Memory-Usage'`
if [[ -n $abc ]]; then
  echo "7. cuda is available."     >> /home/$USER/Desktop/tested.txt
else
   echo "7. cuda NOT available"    >> /home/$USER/Desktop/tested.txt
fi

###############3

abc=
abc=`node --version | grep '22'`
if [[ -n $abc ]]; then
  echo "8. nodejs ver 22.x is installed"     >> /home/$USER/Desktop/tested.txt
else
   echo "8. nodejs ver 22.x not installed"   >> /home/$USER/Desktop/tested.txt
fi

abc=
abc=`node --version | grep '8'`
if [[ -n $abc ]]; then
  echo "9. npm ver 8.x is installed"     >> /home/$USER/Desktop/tested.txt
else
   echo "8. npm ver 8.x not installed"    >> /home/$USER/Desktop/tested.txt
fi

echo "   "        >> /home/$USER/Desktop/tested.txt
echo "======"     >> /home/$USER/Desktop/tested.txt
abc=`ollama list`
echo $abc          >> /home/$USER/Desktop/tested.txt
echo "======"     >> /home/$USER/Desktop/tested.txt








     
