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


dnf module disable mysql -y &>> $LOGFILE

VALIDATE $? "disable current mysql version"


cp mysql.repo /etc/yum.repos.d/mysql.repo &>> $LOGFILE

VALIDATE $? "Copied mysql repo"


dnf install mysql-community-server -y &>> $LOGFILE

VALIDATE $? "installing mysql server"

systemctl enable mysqld &>> $LOGFILE

VALIDATE $? "enable mysql server"

systemctl start mysqld &>> $LOGFILE

VALIDATE $? "start mysql server"

mysql_secure_installation --set-root-pass RoboShop@1 &>> $LOGFILE

VALIDATE $? "set mysql server password"

