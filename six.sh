#!/bin/bash
number1=$1
number2=$2

sum=$(($number1+$number2))

echo "total is $sum"

echo "how many args are passed :: $#"

echo "diplay all args passed :: $@"

echo "script name is $0"