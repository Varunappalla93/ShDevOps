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

# echo "All arguments passed: $@"

for package in $@:
do
    yum list installed $package &>> $LOGFILE # to check installed or not
    if [ $? -ne 0 ]
    then 
        yum install $package -y &>> $LOGFILE   # installl if not installed
        VALIDATE $? "installation of $package" # validate
    else
        echo -e "$package already installed...$Y , hence skipping $N"
    fi
done