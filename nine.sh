#!/bin/bash

ID=$(id -u)

if [ $ID -ne 0 ]
then
    echo "Please run the script with root access"
    exit 1    # any no other than 0
else
    echo "you are root user."
fi

yum install mysql -y