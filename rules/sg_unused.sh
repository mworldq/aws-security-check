#!/bin/bash

# result_code = 0, Miss, Safe
# result_code = 1, Hit, Danger
# result_code = 11, Danger Detail

printf "vvvvvvvvvv Execute Check - $(basename $0) Start: vvvvvvvvvv\n "

# lists all unused AWS security groups.
# a group is considered unused if it's not attached to any network interface.
# requires aws-cli and jq.
# all groups
aws ec2 describe-security-groups --query 'SecurityGroups[*].GroupId' --output text | tr '\t' '\n' > /tmp/sg.all
# groups in use
aws ec2 describe-instances --query 'Reservations[*].Instances[*].SecurityGroups[*].GroupId' --output text | tr '\t' '\n' | sort | uniq > /tmp/sg.in.use
# gourps unused
check_result=`diff /tmp/sg.all /tmp/sg.in.use |grep "<" |cut -d ' ' -f2-3 | wc -l`

result_code=0
result_msg='SecurityGroups Check: You do NOT have unused SecurityGroups.'
result_detail=""

if [ "$check_result" -gt "0" ];then
  result_code=1
  result_msg='SecurityGroups: You have unused SecurityGroups:'
  result_detail=`diff /tmp/sg.all /tmp/sg.in.use |grep "<" |cut -d ' ' -f2-3 `
fi

echo $result_code','$result_msg >> /tmp/check_result.log
for dd in $result_detail
do
  echo '11,'SecurityGroup-ID:$dd >> /tmp/check_result.log
done

printf "%s\n" "$result_msg"
printf "^^^^^^^^^^ Execute Check - $(basename $0) Completed. ^^^^^^^^^^\n "