#!/bin/bash

# result_code = 1, Hit, Danger
# result_code = 0, Miss, Safe

password_useds=`aws iam list-users --query "Users[*].PasswordLastUsed" --output text  | tr '\t' '\n'`

result_code=0
result_msg="IAM Check: The activated user has used the password in the past 30 days."

# Last 30 days timeline
deadline_date=`date -d "-1 month " +%s `

for password_used in ${password_useds}
do
  start_date=`date -d "${password_used%T*}" +%s `

  if  [ $deadline_date -gt $start_date ] ;then
    result_code=1
    result_msg="IAM Check: The activated user has NOT used the password in the past 30 days."
  fi
done

echo $result_code','$result_msg >> /tmp/check_result.log

printf '%s' $result_msg
printf '\n'