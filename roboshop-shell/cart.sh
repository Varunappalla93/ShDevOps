#!/bin/bash

R="\e[31m",
G="\e[32m",
Y="\e[33m",
N="\e[0m",

TIMESTAMP=$( date +%F-%H-%M-%S)
LOGFILE=/tmp/"$0-$TIMESTAMP.log"


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

curl -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip &>> $LOGFILE

VALIDATE $? "Downloading cart app" 


cd /app &>> $LOGFILE

unzip -o /tmp/cart.zip &>> $LOGFILE

VALIDATE $? "unzipping cart" 

npm install &>> $LOGFILE

VALIDATE $? "installing dependencies" 

# we use absolute path as cart service is in that path
cp /home/centos/ShDevOps/roboshop-shell/cart.service /etc/systemd/system/cart.service

VALIDATE $? "Copying cart service file" 

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "cart deamon reload" 

systemctl enable cart &>> $LOGFILE

VALIDATE $? "cart enable" 

systemctl start cart &>> $LOGFILE

VALIDATE $? "cart start" 
