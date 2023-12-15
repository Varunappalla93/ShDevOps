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

dnf install maven -y &>> $LOGFILE

id roboshop
if [ $? -ne 0 ]
then
    useradd roboshop
    VALIDATE $? "roboshop creation user"
else
    echo -e "roboshop user exists $Y , hence skipping $N"
fi

mkdir -p /app

VALIDATE $? "Creating app directory" &>> $LOGFILE

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip &>> $LOGFILE

VALIDATE $? "Download ship app"

cd /app

VALIDATE $? "move to app directory"

unzip -o /tmp/shipping.zip &>> $LOGFILE 

VALIDATE $? "unzip shipping"

mvn clean package &>> $LOGFILE

VALIDATE $? "installing dependencies"

mv target/shipping-1.0.jar shipping.jar &>> $LOGFILE

VALIDATE $? "renaming jar file"

cp /home/centos/ShDevOps/roboshop-shell/shipping.service /etc/systemd/system/shipping.service &>> $LOGFILE

VALIDATE $? "copying shipping service"

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "deamon reload"

systemctl enable shipping &>> $LOGFILE

VALIDATE $? "enable shipping"

systemctl start shipping &>> $LOGFILE

VALIDATE $? "start shipping"

dnf install mysql -y &>> $LOGFILE

VALIDATE $? "install mysql client"

mysql -h mysqldb.vandevops.online -uroot -pRoboShop@1 < /app/schema/shipping.sql

VALIDATE $? "loading  shipping data client"

systemctl restart shipping &>> $LOGFILE

VALIDATE $? "restart shipping"