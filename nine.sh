#!/bin/bash

ID=$(id -u)

if [ $ID -ne 0 ]
then
    echo "Please run the script with root access"
    exit 1    # give any no other than 0, to exit here
else
    echo "you are root user."
fi

yum install mysql -y

if [ $? -ne 0 ]:
then 
    echo "installing mySQL failed"
    exit 1
else
    echo "installed mysql successfully"
fi
