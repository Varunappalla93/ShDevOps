#!/bib/bash

DISK_USAGE=$(df -hT | grep -vE 'tmp|File')

DISK_THRESHHOLD=1

message=""

while IFS= read line
do
    usage=$(echo $line | awk '{print $6F}' | cut -d % -f1)
    partition=$(echo df -HT | grep -vE 'tmp|File'| awk '{print $1F}')

    if [ $DISK_USAGE -gt $DISK_THRESHHOLD ]
    then
        message+="High Disk Usage on $partition:$usage \n"
    fi
done <<< $DISk_USAGE

echo -e "Message: $message"
