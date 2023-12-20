#!/bin/bash

NAME=""
WISHES="Good Morning"

USAGE()
{
    echo "USAGE :: $(basename $0) -n <name> -w <wishes>"
    echo "Options ::"
    echo " -n, Specify the name (mandatory)"
    echo " -w, Specify the wishes, (Optional) Default is Good Morning"
    echo " -h, Display Help and Exit"
}

while getopts ":n:w:h" opt;do
    case $opt in 
        n) NAME="$OPTARG";;
        w) WISHES="$OPTARG";;
        \?) echo "invalid option - "$OPTARG"" >&2; USAGE; exit;;
        h|*) USAGE; exit;;
        :) USAGE; exit;;
    esac
done

# if [ -z "$NAME" ] || [ -z $"WISHES" ]; then
if [ -z "$NAME" ]; then # wishes is optional now
    echo "ERROR : BOTH -n and -w are mandatory"
    USAGE
    exit 1
fi


echo "HELLO $NAME, $WISHES I am learning shell script"