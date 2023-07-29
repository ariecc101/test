#!/bin/bash
Help()
{
   # Display Help
   echo "RUN"
   echo "deploy.sh dir-of-service"
   echo 
   echo "EXAMPLE"
   echo "deploy.sh /home/go-hello-world"
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

if [ -z "$1" ]; then
    echo "No arguments supplied"
    exit 1
fi

DIR_SERVICE=$1
NAME=$(basename $DIR_SERVICE)

cd $DIR_SERVICE
git fetch --all && git pull origin trunk
go mod download && go mod tidy
go build -o $NAME
systemctl restart $NAME
# systemctl status $NAME