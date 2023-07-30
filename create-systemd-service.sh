#!/bin/bash

Help()
{
   # Display Help
   echo_with_color "$GREEN_BOLD" "RUN"
   echo_with_color "$GREEN_BOLD" "create-systemd-service.sh service-name dir-of-service"
   echo_with_color "$GREEN_BOLD" 
   echo_with_color "$GREEN_BOLD" "EXAMPLE"
   echo_with_color "$GREEN_BOLD" "create-systemd-service.sh go-hello-world /home/go-hello-world"
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
#RUN
#create-systemd-service.sh service-name dir-of-service
#Example :
#create-systemd-service.sh go-hello-world /data/ms/go-hello-world

URL_SOURCE=https://raw.githubusercontent.com/ariecc101/backup/main/base_service
BASEDIR=/usr/local/src/service
SOURCE=$BASEDIR/base_service
DEST=/usr/lib/systemd/system
NAME=$1
SERVICE_DIR=$2
TEMP=$BASEDIR/service-temp

if [ -z "$1" ] || [ -z "$2" ]; then
    echo_with_color "$RED_BOLD" "No arguments supplied"
    exit 1
fi

if [ ! -d "$BASEDIR" ]; then
    mkdir -pv $BASEDIR
fi

if [ ! -d "$SERVICE_DIR" ]; then
    echo_with_color "$RED_BOLD" "Wrong Service Directory $SERVICE_DIR"
    exit 1
fi

if [ ! -d "$TEMP" ]; then
    mkdir -pv $TEMP
fi

if [ ! -f "$SOURCE" ]; then
    wget $URL_SOURCE -O $SOURCE
fi

cp $SOURCE $TEMP/$NAME.service
sed -i "s#WORK_DIR#$SERVICE_DIR#g" $TEMP/$NAME.service
sed -i "s#NAME_SERVICE#$NAME#g" $TEMP/$NAME.service
sed -i 's#//#/#g' $TEMP/$NAME.service

cp $TEMP/$NAME.service $DEST/$NAME.service

systemctl daemon-reload
systemctl enable --now $NAME

echo_with_color "$GREEN_BOLD" "Created Successfully Systemd Service $NAME"
# systemctl status $NAME