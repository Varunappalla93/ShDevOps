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


dnf install python36 gcc python3-devel -y

id roboshop # if roboshop does not exist, then its failure, hence set -e we wont use here, as it wil fail entire script
if [ $? -ne 0 ]
then
    useradd roboshop
    VALIDATE $? "roboshop creation user"
else
    echo -e "roboshop user exists $Y , hence skipping $N"
fi


mkdir /app 

curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip

cd /app 

unzip -o /tmp/payment.zip &>> $LOGFILE 

cd /app 

pip3.6 install -r requirements.txt

cp /home/centos/ShDevOps/roboshop-shell/payment.service /etc/systemd/system/payment.service

systemctl daemon-reload

systemctl enable payment 

systemctl start payment