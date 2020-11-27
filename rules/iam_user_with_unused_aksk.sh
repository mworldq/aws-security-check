#!/bin/bash

# result_code = 0, Miss, Safe
# result_code = 1, Hit, Danger
# result_code = 11, Danger Detail

printf "vvvvvvvvvv Execute Check - $(basename $0) Start: vvvvvvvvvv\n "

usernames=`aws iam list-users --query "Users[*].UserName" --output text  | tr '\t' '\n'`

result_code=0
result_msg="IAM Check: All your IAM user's aksk have been used."
result_detail=""

for username in ${usernames}
do
  aks=`aws iam list-access-keys --user-name $username --query "AccessKeyMetadata[*].AccessKeyId" --output text  | tr '\t' '\n'`
  for ak in ${aks}
  do
    aklu=`aws iam get-access-key-last-used --access-key-id $ak --query "AccessKeyLastUsed.LastUsedDate" --output text  | tr '\t' '\n'`
    if  [ "None" == "$aklu" ] ;then
      result_code=1
      result_msg="IAM Check: You have aksk which has NOT been used yet:"
      result_detail=$result_detail" $username's-AK:$ak"
    fi
  done
done

echo $result_code','$result_msg >> /tmp/check_result.log
for dd in $result_detail
do
  echo '11,'$dd >> /tmp/check_result.log
done

printf "%s\n" "$result_msg"
printf "^^^^^^^^^^ Execute Check - $(basename $0) Completed. ^^^^^^^^^^\n "