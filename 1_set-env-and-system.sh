#!/bin/bash

Help()
{
   # Display Help
   echo "RUN"
   echo "1_set-env-and-system.sh dir-of-service"
   echo 
   echo "EXAMPLE"
   echo "1_set-env-and-system.sh /home/go-hello-world"
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
NAME=$(basename $DEST_DIR_SERVICE)
BASE_ENV=$DEST_DIR_SERVICE.env
CURRENT_DIR=`pwd`

if [ ! -f "$BASE_ENV" ]; then
    echo "Directory $BASE_ENV doesnt exist"
    exit 1
fi

if [ -z "$1" ]; then
    echo "No arguments supplied"
    exit 1
fi

cd $DEST_DIR_SERVICE
cp $BASE_ENV $DEST_DIR_SERVICE
go mod download && go mod tidy
go build -o $NAME

$CURRENT_DIR/create-systemd-service.sh $NAME $DEST_DIR_SERVICE