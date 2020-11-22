#!/bin/bash

# result_code = 1, Hit, Danger
# result_code = 0, Miss, Safe

check_result=`aws ec2 describe-security-groups --filters "Name=ip-permission.to-port,Values=6379" --query 'SecurityGroups[?length(IpPermissions[?ToPort==\`6379\` && contains(IpRanges[].CidrIp, \`0.0.0.0/0\`)]) > \`0\`].GroupId'  --output text  | tr '\t' '\n' | wc -l`

result_code=0
result_msg="SecurityGroups Check: There are restrictions on your service with Port 6379 or no service used."

if [ "$check_result" -gt "0" ];then
  result_code=1
  result_msg="SecurityGroups Check: Your service with Port 6379 is open to the world."
fi
echo $result_code','$result_msg >> /tmp/check_result.log

printf '%s' $result_msg
printf '\n'