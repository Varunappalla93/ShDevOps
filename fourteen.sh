#!/bin/bash

set -e
ls -ltr

touch example.txt

echo "before wrong command"

lss

cd /tmp

echo "after wrong command"


cd /home/centos
