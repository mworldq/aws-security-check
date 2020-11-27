#!/bin/bash

# result_code = 1, Hit, Danger
# result_code = 0, Miss, Safe

printf "vvvvvvvvvv Execute Check - $(basename $0) Start: vvvvvvvvvv\n "

users=`aws iam list-users --query "Users[*].UserName" --output text  | tr '\t' '\n' | wc -l`

password_used=`aws iam list-users --query "Users[*].PasswordLastUsed" --output text  | tr '\t' '\n' | wc -l`

result_code=0
result_msg="IAM Check: All your IAM users have been activated."

if [ "$users" -gt "$password_used" ];then
  result_code=1
  result_msg="IAM Check: You have users who have NOT been activated yet."
fi
echo $result_code','$result_msg >> /tmp/check_result.log

printf "%s\n" "$result_msg"
printf "^^^^^^^^^^ Execute Check - $(basename $0) Completed. ^^^^^^^^^^\n "