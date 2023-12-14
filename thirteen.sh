#!/bin/bash

R="\e[31m",
G="\e[32m",
N="\e[0m",


ID=$(id -u)  # to check user id


if [ $ID -ne 0 ]
then
    echo -e "$R Please run the script with root access $N"
    exit 1    # give any no other than 0, to exit here
else
    echo "you are root user"
fi

echo "All arguments passed: $@"





