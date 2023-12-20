#!/bin/bash

AMI=ami-03265a0778a880afb 
SG_ID=sg-00217dc8cbd2f0637
INSTANCES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "web")
# ZONE_ID=Z104317737D96UJVA7NEF
# DOMAIN_NAME="daws76s.online"

for i in "${INSTANCES[@]}"
do
    if [ $i == "mongodb" ] || [ $i == "mysql" ] || [ $i == "shipping" ]
    then
        INSTANCE_TYPE="t3.small"
    else
        INSTANCE_TYPE="t2.micro"
    fi

    aws ec2 run-instances --image-id ami-03265a0778a880afb --instance-type $INSTANCE_TYPE --security-group-ids sg-00217dc8cbd2f0637
done


