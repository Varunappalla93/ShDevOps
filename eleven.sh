#!/bin/bash

VALIDATE()
{
    if [ $1 -ne 0 ]
    then 
        echo "installing $2 is failed"
        exit 1
    else
        echo "installed $2 done successfully"
    fi

}

ID=$(id -u)  # to chec user id
TIMESTAMP=$( date +%F-%H-%M-%S)

$LOGFILE=/tmp/"$0-$TIMESTAMP.log"

echo "Script name : $0"

if [ $ID -ne 0 ]
then
    echo "Please run the script with root access"
    exit 1    # give any no other than 0, to exit here
else
    echo "you are root user."
fi


yum install mysql -y &>> $LOGFILE

VALIDATE $? "MYSQL"

yum install git -y &>> $LOGFILE

VALIDATE $? "GIT" 
