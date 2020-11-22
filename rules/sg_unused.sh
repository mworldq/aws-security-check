#!/bin/bash

# result_code = 1, Hit, Danger
# result_code = 0, Miss, Safe

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
if [ "$check_result" -gt "0" ];then
  result_code=1
  result_msg='SecurityGroups: You have unused SecurityGroups.'
fi
echo $result_code','$result_msg >> /tmp/check_result.log

printf '%s' $result_msg
printf '\n'