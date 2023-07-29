#!/bin/bash

Help()
{
   # Display Help
   echo "RUN"
   echo "create-systemd-service.sh service-name dir-of-service"
   echo 
   echo "EXAMPLE"
   echo "create-systemd-service.sh go-hello-world /home/go-hello-world"
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
    echo "No arguments supplied"
    exit 1
fi

if [ ! -d "$BASEDIR" ]; then
    mkdir -pv $BASEDIR
fi

if [ ! -d "$SERVICE_DIR" ]; then
    echo "Wrong Service Directory $SERVICE_DIR"
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

echo "Created Successfully Systemd Service $NAME"
# systemctl status $NAME