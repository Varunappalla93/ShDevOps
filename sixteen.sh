#!/bin/bash

R="\e[31m",
G="\e[32m",
Y="\e[33m",
N="\e[0m",




if [ ! -d $src_directory ] # ! is opposite
then
    echo "$R src directory : $src_directory does not exist. $N"
fi


file="/etc/passwd"
while IFS=":" read -r username password userid groupid userfullname homedirectory shellpath
do
    echo "username : $username"
    echo "userid:  $userid"
    echo "user full name : $userfullname"
done < $file

