#!/bin/bash

Help()
{
   # Display Help
   echo_with_color "$GREEN_BOLD" "RUN"
   echo_with_color "$GREEN_BOLD" "1_set-env-and-system.sh dir-of-service"
   echo_with_color "$GREEN_BOLD" 
   echo_with_color "$GREEN_BOLD" "EXAMPLE"
   echo_with_color "$GREEN_BOLD" "1_set-env-and-system.sh /home/go-hello-world"
}

GREEN_BOLD='\033[1;32m'
RED_BOLD='\033[1;31m'
RESET_COLOR='\033[0m'

function echo_with_color {
    local color="$1"
    local message="$2"
    echo -e "${color} ${message}${RESET_COLOR}"
}

while getopts ":h" option; do
   case $option in
      h) # display Help
         Help
         exit;;
     \?) # incorrect option
         echo_with_color "$RED_BOLD" "Error: Invalid option"
         exit;;
   esac
done

DEST_DIR_SERVICE=$1
NAME=$(basename $DEST_DIR_SERVICE)
BASE_ENV=$DEST_DIR_SERVICE.env
CURRENT_DIR=`pwd`

if [ -z "$1" ]; then
    echo_with_color "$RED_BOLD" "No arguments supplied"
    exit 1
fi

if [ ! -f "$BASE_ENV" ]; then
    echo_with_color "$RED_BOLD" "File $BASE_ENV doesnt exist"
    echo_with_color "$RED_BOLD" "First, set .env in $DEST_DIR_SERVICE"
    exit 1
fi


cd $DEST_DIR_SERVICE
cp $BASE_ENV $DEST_DIR_SERVICE
go mod download && go mod tidy
go build -o $NAME

$CURRENT_DIR/create-systemd-service.sh $NAME $DEST_DIR_SERVICE