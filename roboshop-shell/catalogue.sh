#!/bin/bash

R="\e[31m",
G="\e[32m",
Y="\e[33m",
N="\e[0m",

TIMESTAMP=$( date +%F-%H-%M-%S)
LOGFILE=/tmp/"$0-$TIMESTAMP.log"

MONGODB_HOST=mongodb.vandevops.online

echo "Script name : $0"
echo "Script started executing at $TIMESTAMP &>> $LOGFILE"

VALIDATE()
{
    if [ $1 -ne 0 ]
    then    
        echo -e $2.....$R Failed ..$N
    else
        echo -e $2.....$G success ..$N
    fi
}


ID=$(id -u)  # to check user id

if [ $ID -ne 0 ]
then
    echo -e "$R Please run the script with root access $N"
    exit 1    # give any no other than 0, to exit here
else
    echo "you are root user"
fi


dnf module disable nodejs -y &>> $LOGFILE

VALIDATE $? "Disabling current node js"

dnf module enable nodejs:18 -y &>> $LOGFILE


VALIDATE $? "Enabling node js 18 "

dnf install nodejs -y &>> $LOGFILE

VALIDATE $? "Install node js 18 "

useradd roboshop

VALIDATE $? "Creating roboshop user"

mkdir /app

VALIDATE $? "Creating app directory" &>> $LOGFILE

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip

VALIDATE $? "Downloading catalogue app" &>> $LOGFILE


cd /app

unzip /tmp/catalogue.zip

VALIDATE $? "unzipping catalogue" &>> $LOGFILE

npm install 

VALIDATE $? "installing dependencies" &>> $LOGFILE

# we use absolute path as catalogue service is in that path
cp /home/centos/ShDevOps/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service

VALIDATE $? "Copying catalogue service file" &>> $LOGFILE

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "catalogue deamon reload" &>> $LOGFILE

systemctl enable catalogue &>> $LOGFILE

VALIDATE $? "catalogue enable" &>> $LOGFILE

systemctl start catalogue &>> $LOGFILE

VALIDATE $? "catalogue start" &>> $LOGFILE

cp /home/centos/ShDevOps/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo

VALIDATE $? "copying mongodb repo" &>> $LOGFILE

dnf install mongodb-org-shell -y

VALIDATE $? "installing mongodb client" &>> $LOGFILE

mongo --host $MONGODB_HOST </app/schema/catalogue.js

VALIDATE $? "Loading catalogue data into mongodb DB" &>> $LOGFILE