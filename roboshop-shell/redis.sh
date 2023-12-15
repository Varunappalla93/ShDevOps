#!/bin/bash

R="\e[31m",
G="\e[32m",
Y="\e[33m",
N="\e[0m",

TIMESTAMP=$( date +%F-%H-%M-%S)
LOGFILE=/tmp/"$0-$TIMESTAMP.log"
exec &>$LOGFILE


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


dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y

VALIDATE $? "Installing remi release"

dnf module enable redis:remi-6.2 -y
VALIDATE $? "enabling redis"

dnf install redis -y

VALIDATE $? "Install redis"

sed -i 's/127\.0\.0\.1/0\.0\.0\.0/g' /etc/redis/redis.conf 

VALIDATE $? "allowing remote connections"

systemctl enable redis

VALIDATE $? "enabled redis"

systemctl start redis

VALIDATE $? "started redis"
