#!/bin/bash

# result_code = 1, Hit, Danger
# result_code = 0, Miss, Safe

usernames=`aws iam list-users --query "Users[*].UserName" --output text  | tr '\t' '\n'`

result_code=0
result_msg="IAM Check: All your IAM user's aksk have been used."

for username in ${usernames}
do
  aks=`aws iam list-access-keys --user-name $username --query "AccessKeyMetadata[*].AccessKeyId" --output text  | tr '\t' '\n'`
  for ak in ${aks}
  do
    aklu=`aws iam get-access-key-last-used --access-key-id $ak --query "AccessKeyLastUsed.LastUsedDate" --output text  | tr '\t' '\n'`
    if  [ "None" == "$aklu" ] ;then
      result_code=1
      result_msg="IAM Check: You have aksk which has NOT been used yet."
    fi
  done
done

echo $result_code','$result_msg >> /tmp/check_result.log

printf '%s' $result_msg
printf '\n'