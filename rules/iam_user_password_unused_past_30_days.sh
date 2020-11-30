#!/bin/bash

# result_code = 0, Miss, Safe
# result_code = 1, Hit, Danger
# result_code = 11, Danger Detail

printf "vvvvvvvvvv Execute Check - $(basename $0) Start: vvvvvvvvvv\n "

password_useds=`aws iam list-users --query "Users[*].PasswordLastUsed" --output text  | tr '\t' '\n'`

result_code=0
result_msg="IAM Check: The activated user has used the password in the past 30 days."
result_detail=""

# Last 30 days timeline
deadline_date=`date -d "-1 month " +%s `

for password_used in ${password_useds}
do
  start_date=`date -d "${password_used%T*}" +%s `

  if  [ $deadline_date -gt $start_date ] ;then
    result_code=1
    result_msg="IAM Check: The activated user has NOT used the password in the past 30 days"
    username=`aws iam list-users --query "Users[?PasswordLastUsed=='2020-11-12T06:17:59Z'].UserName" --output text  | tr '\t' '\n'`
    result_detail=$result_detail" UserName:$username"
  fi
done

echo $result_code','$result_msg >> /tmp/check_result.log
for dd in $result_detail
do
  echo '11,'$dd >> /tmp/check_result.log
done

printf "%s\n" "$result_msg"
printf "^^^^^^^^^^ Execute Check - $(basename $0) Completed. ^^^^^^^^^^\n "