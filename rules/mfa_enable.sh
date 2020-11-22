#!/bin/bash

# result_code = 1, Hit, Danger
# result_code = 0, Miss, Safe

check_result=`aws iam list-mfa-devices --query "MFADevices" --output text  | tr '\t' '\n' | wc -l`

result_code=0
result_msg='MFA Check: You have MFADevices'
if [ "$check_result" -eq "0" ];then
  result_code=1
  result_msg='MFA Check: You do NOT have MFADevices'
fi
echo $result_code','$result_msg >> /tmp/check_result.log

printf '%s' $result_msg
printf '\n'