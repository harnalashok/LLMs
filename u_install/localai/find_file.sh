#!/bin/bash

# Usage: 
#    To find tinyllama, search as:
#         ./find_file.sh tiny
#    To search for a model having the word 'function', search as:
#	  ./find_file.sh  *function

if [[ $# -eq 0 ]] ; then
    echo "Usage: ./find_file.sh fileName  to search for: fileNameXYZ.ABC "
    echo "OR    ./find_file.sh *XY        to search for: fileNameXYZ.ABC "
    echo 'Supply name of the file as: tiny for tinyllama and even *tiny would work. '
    echo "But do not put * at the end of your search term ie NO tiny*"	
    exit 0
fi


# sudo find / -iname 'llama-3.2-1b*' 2>/dev/null
sudo find / -iname  $1'*'  2>/dev/null
