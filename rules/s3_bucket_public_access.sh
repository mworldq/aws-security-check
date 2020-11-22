#!/bin/bash

# result_code = 1, Hit, Danger
# result_code = 0, Miss, Safe

buckets=`aws s3api list-buckets  --query 'Buckets[*].Name' --output text  | tr '\t' '\n'`

result_code=0
result_msg="S3 Check: There is no public access to S3 bucket."

for bucket in ${buckets}
do
  check_result=`aws s3api get-public-access-block --bucket $bucket --query 'PublicAccessBlockConfiguration'  --output text  | tr '\t' '\n' | grep -v 'True' | wc -l`
  if [ "$check_result" -gt "0" ] ;then
    result_code=1
    result_msg="S3 Check: One or more buckets has public access."
  fi
done

echo $result_code','$result_msg >> /tmp/check_result.log

printf '%s' $result_msg
printf '\n'