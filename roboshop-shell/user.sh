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
        exit 1
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

id roboshop # if roboshop does not exist, then its failure, hence set -e we wont use here, as it wil fail entire script
if [ $? -ne 0 ]
then
    useradd roboshop
    VALIDATE $? "roboshop creation user"
else
    echo -e "roboshop user exists $Y , hence skipping $N"
fi

mkdir -p /app

VALIDATE $? "Creating app directory" &>> $LOGFILE

curl -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip &>> $LOGFILE

VALIDATE $? "Downloading user app" 


cd /app

unzip -o /tmp/user.zip &>> $LOGFILE

VALIDATE $? "unzipping user" 

npm install &>> $LOGFILE

VALIDATE $? "installing dependencies" 

# we use absolute path as user service is in that path
cp /home/centos/ShDevOps/roboshop-shell/user.service /etc/systemd/system/user.service


VALIDATE $? "Copying user service file" 

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "user deamon reload" 

systemctl enable user &>> $LOGFILE

VALIDATE $? "user enable" 

systemctl start user &>> $LOGFILE

VALIDATE $? "user start" 

cp /home/centos/ShDevOps/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo

VALIDATE $? "copying mongodb repo" 

dnf install mongodb-org-shell -y &>> $LOGFILE

VALIDATE $? "installing mongodb client" 

mongo --host $MONGODB_HOST </app/schema/user.js &>> $LOGFILE

VALIDATE $? "Loading user data into mongoDB"