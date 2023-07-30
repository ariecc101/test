#!/bin/bash
Help()
{
   # Display Help
   echo_with_color "$GREEN_BOLD" "RUN"
   echo_with_color "$GREEN_BOLD" "showlog.sh dir-of-service"
   echo_with_color "$GREEN_BOLD"
   echo_with_color "$GREEN_BOLD" "EXAMPLE"
   echo_with_color "$GREEN_BOLD" "showlog.sh /home/go-hello-world"
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

if [ -z "$1" ]; then
    echo_with_color "$RED_BOLD" "No arguments supplied"
    exit 1
fi

HOME=$1
NAME=$(basename $HOME)


if [ ! -d "$HOME" ]; then
    echo_with_color "$RED_BOLD" "Directory $HOME doesnt exist"
    exit 1
fi

journalctl -fu $NAME