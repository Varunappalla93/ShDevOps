#!/bin/bash

set -e   # to stop at errors
ls -ltr

touch example.txt

echo "before wrong command"

lss

cd /tmp

echo "after wrong command"


cd /home/centos
