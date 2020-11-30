#!/bin/bash

# result_code = 0, Miss, Safe
# result_code = 1, Hit, Danger
# result_code = 11, Danger Detail

printf "vvvvvvvvvv Execute Check - $(basename $0) Start: vvvvvvvvvv\n "

#users=`aws iam list-users --query "Users[*].UserName" --output text  | tr '\t' '\n' | wc -l`
aws iam list-users --query 'Users[*].UserName' --output text | tr '\t' '\n' > /tmp/users.all

#password_used=`aws iam list-users --query "Users[*].PasswordLastUsed" --output text  | tr '\t' '\n' | wc -l`
aws iam list-users --query "Users[?PasswordLastUsed].UserName" --output text | tr '\t' '\n' > /tmp/users.in.use

check_result=`diff /tmp/users.all /tmp/users.in.use |grep "<" |cut -d ' ' -f2-3 | wc -l`

result_code=0
result_msg="IAM Check: All your IAM users have been activated."
result_detail=""

if [ "$check_result" -gt "0" ];then
  result_code=1
  result_msg="IAM Check: You have users who have NOT been activated yet."
  result_detail=`diff /tmp/users.all /tmp/users.in.use |grep "<" |cut -d ' ' -f2-3 `
fi

echo $result_code','$result_msg >> /tmp/check_result.log
for dd in $result_detail
do
  echo '11,'Unused-UserName:$dd >> /tmp/check_result.log
done

printf "%s\n" "$result_msg"
printf "^^^^^^^^^^ Execute Check - $(basename $0) Completed. ^^^^^^^^^^\n "