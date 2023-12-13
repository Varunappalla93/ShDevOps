#!/bin/bash
R="\e[31m",
G="\e[32m",
N="\e[0m",


VALIDATE()
{
    if [ $1 -ne 0 ]
    then 
        echo -e "ERROR installing $2 is $R failed $N"
        exit 1
    else
        echo -e "installed $2 done $G successfully $N"
    fi

}

ID=$(id -u)  # to check user id
TIMESTAMP=$( date +%F-%H-%M-%S)
LOGFILE=/tmp/"$0-$TIMESTAMP.log"

echo "Script name : $0"
echo "Script started executing at $TIMESTAMP &>> $LOGFILE"


if [ $ID -ne 0 ]
then
    echo -e "$R Please run the script with root access $N"
    exit 1    # give any no other than 0, to exit here
else
    echo "you are root user."
fi


yum install mysql -y &>> $LOGFILE

VALIDATE $? "MYSQL"

yum install git -y &>> $LOGFILE

VALIDATE $? "GIT" 