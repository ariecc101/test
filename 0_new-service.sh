#!/bin/bash

Help()
{
   # Display Help
   echo "RUN"
   echo "0_new-service.sh dir-of-service SCM_URL"
   echo 
   echo "EXAMPLE"
   echo "0_new-service.sh /home/go-hello-world https://github.com/ariecc101/go-hello-word.git"
}

while getopts ":h" option; do
   case $option in
      h) # display Help
         Help
         exit;;
     \?) # incorrect option
         echo "Error: Invalid option"
         exit;;
   esac
done

DEST_DIR_SERVICE=$1
URL_REPO=$2

if [ -z "$1" ] || [ -z "$2" ]; then
    echo "No arguments supplied"
    exit 1
fi

if [ -d "$DEST_DIR_SERVICE" ]; then
    echo "Directory $DEST_DIR_SERVICE exist"
    exit 1
fi

git clone $URL_REPO $DEST_DIR_SERVICE