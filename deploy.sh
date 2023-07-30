#!/bin/bash
Help()
{
   # Display Help
   echo_with_color "$GREEN_BOLD" "RUN"
   echo_with_color "$GREEN_BOLD" "deploy.sh dir-of-service name-branch"
   echo_with_color "$GREEN_BOLD"
   echo_with_color "$GREEN_BOLD" "EXAMPLE"
   echo_with_color "$GREEN_BOLD" "deploy.sh /home/go-hello-world main"
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

NAME_BRANCH=$2

if [ -z "$1" ] || [ -z "$2" ]; then
    echo_with_color "$RED_BOLD" "No arguments supplied"
    exit 1
fi


DIR_SERVICE=$1
NAME=$(basename $DIR_SERVICE)

if [ ! -d $1 ]; then
    echo_with_color "$RED_BOLD" "Directory $NAME doesnt exist"
    exit 1
fi

cd $DIR_SERVICE

if ! git rev-parse --verify "$NAME_BRANCH" >/dev/null 2>&1 ; then
   echo_with_color "$RED_BOLD" "Branch name $NAME_BRANCH doesnt exists."
   exit 1
fi

git fetch --all && git pull origin $NAME_BRANCH
go mod download && go mod tidy
go build -o $NAME
systemctl restart $NAME
# echo -e "${GREEN_BOLD} Successfully Deploy Service $NAME ${RESET_COLOR}"
echo_with_color "$GREEN_BOLD" "Successfully Deploy Service $NAME"
# systemctl status $NAME
