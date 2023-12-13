#!/bin/bash

number=$1

if [ number -gt 100]
then
    echo "Given no $number is greater than 100"
else
    echo "Given no $number is not greater than 100"
fi