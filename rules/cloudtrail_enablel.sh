#!/bin/bash

# result_code = 1, Hit, Danger
# result_code = 0, Miss, Safe

printf "vvvvvvvvvv Execute Check - $(basename $0) Start: vvvvvvvvvv\n "

check_result=`aws cloudtrail list-trails --query "Trails[*].TrailARN" --output text  | tr '\t' '\n' | wc -l`

result_code=0
result_msg="Cloudtrail Check: You have started the Cloudtrail service."

if [ "$check_result" -eq "0" ];then
  result_code=1
  result_msg="Cloudtrail Check: You have NOT started the Cloudtrail service."
fi
echo $result_code','$result_msg >> /tmp/check_result.log

printf "%s\n" "$result_msg"
printf "^^^^^^^^^^ Execute Check - $(basename $0) Completed. ^^^^^^^^^^\n "