#!/bin/bash

# Last amended: 15th June, 2026

# Delete earlier report
rm /home/$USER/test_report.txt


# Stop software, if started
echo "Stopping services, if started..."
echo "========="
sleep 2

nn=
nn=`sudo ss -tulpn | grep ':5678'`

if [[ -n $nn ]]; then
  echo "Stopping n8n"
  docker stop n8n
fi

ol=
ol=`sudo ss -tulpn | grep ':11434'`

if [[ -n $ol ]]; then
  echo "Stopping ollama docker"
  docker stop ollama
fi


chr=
chr=`sudo ss -tulpn | grep ':8000'`

if [[ -n $chr ]]; then
  echo "Stopping chromadb"
  docker stop chroma
fi


flo=
flo=`sudo ss -tulpn | grep ':3000'`

if [[ -n $flo ]]; then
  echo "Stopping flowise"
  docker stop flowise
fi

echo "   "
echo "DONE....."
echo "   "
echo "    "
echo "Starting services"

# Start apps
echo "   "
echo "======  "
echo "Starting flowise   "
bash start_flowise.sh
sleep 3
echo "  "
echo "======  "
echo "Starting Ollama   "
bash start_ollama.sh
sleep 3
echo "  "
echo "======  "
echo "Starting n8n   "
bash start_n8n.sh
sleep 3
echo "  "
echo "======  "
echo "Starting Chroma   "
bash start_chroma.sh
echo "  "
echo "======  "
echo "Starting meilisearch   "
bash start_meilisearch.sh 
sleep 3
echo "  "
echo "======  "
echo "Starting Postgres   "
bash start_postgresql.sh
sleep 3

echo "  "
echo "   "
echo "======="                 > /home/$USER/test_report.txt
echo "Test Report"            >> /home/$USER/test_report.txt
echo "======="                 >> /home/$USER/test_report.txt
echo "    "                    >> /home/$USER/test_report.txt


nn=
nn=`sudo ss -tulpn | grep ':5678'`
if [[ -n $nn ]]; then
  echo "1. n8n is started."  >> /home/$USER/test_report.txt
else
   echo "1. n8n NOT started"  >> /home/$USER/test_report.txt
fi

# Test ollama
ol=
ol=`sudo ss -tulpn | grep ':11434'`
if [[ -n $ol ]]; then
  echo "2. ollama is started."    >> /home/$USER/test_report.txt
else
   echo "2. ollama NOT started"  >> /home/$USER/test_report.txt
fi

# Test postgres
pg=
pg=`sudo ss -tulpn | grep ':5432'`
if [[ -n $pg ]]; then
  echo "3. postgres is started."    >> /home/$USER/test_report.txt
else
   echo "3. postgres NOT started"    >> /home/$USER/test_report.txt
fi


chr=
chr=`sudo ss -tulpn | grep ':8000'`

if [[ -n $chr ]]; then
  echo "4. chromadb is started."     >> /home/$USER/test_report.txt
else
   echo "4. chromadb NOT started"    >> /home/$USER/test_report.txt
fi

mei=
mei=`sudo ss -tulpn | grep ':7700'`
if [[ -n $mei ]]; then
  echo "5. meilisearch is started."     >> /home/$USER/test_report.txt
else
   echo "5. meilisearch NOT started"   >> /home/$USER/test_report.txt
fi

sleep 3
flo=
flo=`sudo ss -tulpn | grep ':3000'`
if [[ -n $flo ]]; then
  echo "6. flowise is started."     >> /home/$USER/test_report.txt
else
   echo "6. flowise is NOT started"    >> /home/$USER/test_report.txt
fi

abc=
abc=`nvidia-smi | grep 'Memory-Usage'`
if [[ -n $abc ]]; then
  echo "7. cuda is available."     >> /home/$USER/test_report.txt
else
   echo "7. cuda NOT available"    >> /home/$USER/test_report.txt
fi

abc=
abc=`node --version | grep '22'`
if [[ -n $abc ]]; then
  echo "8. nodejs ver 22.x is installed"     >> /home/$USER/test_report.txt
else
   echo "8. nodejs ver 22.x appears to be not installed"   >> /home/$USER/test_report.txt
fi

abc=
abc=`npm --version | grep '10'`
if [[ -n $abc ]]; then
  echo "9. npm ver 10.x is installed"     >> /home/$USER/test_report.txt
else
   echo "8. npm ver 10.x not installed"    >> /home/$USER/test_report.txt
fi

sleep 2
echo "    "                              >> /home/$USER/test_report.txt
echo "    "                              >> /home/$USER/test_report.txt
echo "==Ollama models downloaded===="     >> /home/$USER/test_report.txt
docker exec -it ollama ollama list         | tee -a  /home/$USER/test_report.txt
echo "======"                             >> /home/$USER/test_report.txt

cat /home/$USER/test_report.txt






     
