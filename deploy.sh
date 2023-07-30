#!/bin/bash
Help()
{
   # Display Help
   echo "RUN"
   echo "deploy.sh dir-of-service name-branch"
   echo 
   echo "EXAMPLE"
   echo "deploy.sh /home/go-hello-world main"
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

NAME_BRANCH=$2

if [ -z "$1" ] || [ -z "$2" ]; then
    echo "No arguments supplied"
    exit 1
fi


DIR_SERVICE=$1
NAME=$(basename $DIR_SERVICE)

if [ ! -d $1 ]; then
    echo "Directory $NAME doesnt exist"
    exit 1
fi

cd $DIR_SERVICE

if ! git rev-parse --verify "$NAME_BRANCH" >/dev/null 2>&1 ; then
   echo "Branch name $NAME_BRANCH doesnt exists."
   exit 1
fi

git fetch --all && git pull origin $NAME_BRANCH
go mod download && go mod tidy
go build -o $NAME
systemctl restart $NAME
echo "Successfully Deploy Service $NAME"
# systemctl status $NAME
