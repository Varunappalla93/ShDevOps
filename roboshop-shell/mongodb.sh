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


cp mongo.repo /etc/yum.repos.d/ &>> $LOGFILE

VALIDATE $? "Copied Mongo Repo"

dnf install mongodb-org -y &>> $LOGFILE

VALIDATE $? "Installing mongoDB"

systemctl enable mongod &>> $LOGFILE

VALIDATE $? "Enabling mongoDB"

systemctl start mongod &>> $LOGFILE


VALIDATE $? "Starting mongoDB"

sed -i 's/127\.0\.0\.1/0\.0\.0\.0/' /etc/mongod.conf &>> $LOGFILE

VALIDATE $? "Remote access to mongoDB"

systemctl restart mongod &>> $LOGFILE

VALIDATE $? "Restart mongoDB"