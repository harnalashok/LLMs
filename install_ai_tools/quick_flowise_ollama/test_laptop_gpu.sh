#!/bin/bash

# Last amended: 07th June, 2026

# Delete earlier report
rm /home/$USER/test_report.txt


echo "   "
echo "    "
echo "Starting services"
echo "==========="
echo "   "
echo "    "

# Stop software, if started
echo "Stopping services, if started..."
docker stop chroma
docker stop ollama
docker stop flowise
docker stop n8n
docker stop meilisearch

echo "  "

# Start apps
bash start_ollama.sh
bash start_postgresql.sh
bash start_n8n.sh
bash start_flowise.sh
bash start_chroma.sh
bash start_meilisearch.sh 
echo "=============="
echo "  "
echo "   "
# Test n8n

#######3

echo "======="         > /home/$USER/test_report.txt
echo "Test Report"     >> /home/$USER/test_report.txt
echo "======="         >> /home/$USER/test_report.txt
echo "    "            >> /home/$USER/test_report.txt



abc=
abc=`sudo ss -tulpn | grep ':5678'`

if [[ -n $abc ]]; then
  echo "1. n8n is started."  >> /home/$USER/test_report.txt
else
   echo "1. n8n NOT installed"  >> /home/$USER/test_report.txt
fi

#######3
# Test ollama
abc=
abc=`sudo ss -tulpn | grep ':11434'`

if [[ -n $abc ]]; then
  echo "2. ollama is started."    >> /home/$USER/test_report.txt
else
   echo "2. ollama NOT installed"  >> /home/$USER/test_report.txt
fi

#######3
# Test postgres

abc=
abc=`sudo ss -tulpn | grep ':5432'`

if [[ -n $abc ]]; then
  echo "3. postgres is started."    >> /home/$USER/test_report.txt
else
   echo "3. postgres NOT installed"    >> /home/$USER/test_report.txt
fi

#######3
abc=
abc=`sudo ss -tulpn | grep ':8000'`

if [[ -n $abc ]]; then
  echo "4. chromadb is started."     >> /home/$USER/test_report.txt
else
   echo "4. chromadb NOT installed"    >> /home/$USER/test_report.txt
fi

#######3

abc=
abc=`sudo ss -tulpn | grep ':7700'`

if [[ -n $abc ]]; then
  echo "5. meilisearch is started."     >> /home/$USER/test_report.txt
else
   echo "5. meilisearch NOT installed"   >> /home/$USER/test_report.txt
fi

###########

abc=
abc=`sudo ss -tulpn | grep ':3000'`

if [[ -n $abc ]]; then
  echo "6. flowise is started."     >> /home/$USER/test_report.txt
else
   echo "6. flowise NOT installed"    >> /home/$USER/test_report.txt
fi

###########


abc=
abc=`nvidia-smi | grep 'Memory-Usage'`
if [[ -n $abc ]]; then
  echo "7. cuda is available."     >> /home/$USER/test_report.txt
else
   echo "7. cuda NOT available"    >> /home/$USER/test_report.txt
fi

###############3

abc=
abc=`node --version | grep '22'`
if [[ -n $abc ]]; then
  echo "8. nodejs ver 22.x is installed"     >> /home/$USER/test_report.txt
else
   echo "8. nodejs ver 22.x not installed"   >> /home/$USER/test_report.txt
fi

abc=
abc=`npm --version | grep '10'`
if [[ -n $abc ]]; then
  echo "9. npm ver 10.x is installed"     >> /home/$USER/test_report.txt
else
   echo "8. npm ver 10.x not installed"    >> /home/$USER/test_report.txt
fi

echo "   "        >> /home/$USER/test_report.txt
echo "======"     >> /home/$USER/test_report.txt
abc=`ollama list`
echo $abc          >> /home/$USER/test_report.txt
echo "======"     >> /home/$USER/test_report.txt

echo "    "
echo "   "
echo "======"
cat /home/$USER/test_report.txt






     
