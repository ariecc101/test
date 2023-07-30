#!/bin/bash

Help()
{
   # Display Help
   echo_with_color "$GREEN_BOLD" "RUN"
   echo_with_color "$GREEN_BOLD" "0_new-service.sh dir-of-service SCM_URL"
   echo_with_color "$GREEN_BOLD" 
   echo_with_color "$GREEN_BOLD" "EXAMPLE"
   echo_with_color "$GREEN_BOLD" "0_new-service.sh /home/go-hello-world https://github.com/ariecc101/go-hello-word.git"
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
URL_REPO=$2

if [ -z "$1" ] || [ -z "$2" ]; then
    echo_with_color "$RED_BOLD" "No arguments supplied"
    exit 1
fi

if [ -d "$DEST_DIR_SERVICE" ]; then
    echo_with_color "$RED_BOLD" "Directory $DEST_DIR_SERVICE exist"
    exit 1
fi

git clone $URL_REPO $DEST_DIR_SERVICE
echo_with_color "$GREEN_BOLD" "Succesfully Clone $URL_REPO to $DEST_DIR_SERVICE"