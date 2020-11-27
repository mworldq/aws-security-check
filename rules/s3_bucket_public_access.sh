#!/bin/bash

# result_code = 0, Miss, Safe
# result_code = 1, Hit, Danger
# result_code = 11, Danger Detail
set +e
printf "vvvvvvvvvv Execute Check - $(basename $0) Start: vvvvvvvvvv\n "

buckets=$(aws s3api list-buckets --query 'Buckets[*].Name' --output text | tr '\t' '\n')

result_code=0
result_msg="S3 Check: There is no public access to S3 bucket."
result_detail=""
flag=0
flag_bucket=""

for bucket in ${buckets}; do
  flag=1
  flag_bucket="$bucket"

  check_result=$(aws s3api get-public-access-block --bucket $bucket --query 'PublicAccessBlockConfiguration' --output text | tr '\t' '\n' | grep -v 'True' | wc -l)

  if [ "$check_result" -gt "0" ]; then
    result_code=1
    result_msg="S3 Check: One or more buckets has public access:"
    result_detail=$result_detail" BucketName:$bucket"
  fi

  flag=0
  flag_bucket=""
done

if [ $flag ]; then
    result_code=1
    result_msg="S3 Check: One or more buckets has public access:"
    result_detail=$result_detail" BucketName:$bucket"
fi

echo $result_code','$result_msg >>/tmp/check_result.log
for dd in $result_detail
do
  echo '11,'$dd >> /tmp/check_result.log
done

printf "%s\n" "$result_msg"
printf "^^^^^^^^^^ Execute Check - $(basename $0) Completed. ^^^^^^^^^^\n "
