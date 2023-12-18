#!/bin/bash

R="\e[31m",
G="\e[32m",
Y="\e[33m",
N="\e[0m",


src_directory=/tmp/shellscript-logs

if [ ! -d $src_directory ] # ! is opposite
then
    echo "$R src directory : $src_directory does not exist. $N"
fi

#  touch -d 20231201 user.log - to create old date files

# find . -type f - to find files

FILES_TO_DELETE=$(find . -type f -mtime +14 name "*.log")

while IFS= read -r line
do
    echo "Deleting file $line"

done <<< $FILES_TO_DELETE


