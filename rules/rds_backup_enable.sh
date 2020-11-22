#!/bin/bash

# result_code = 1, Hit, Danger
# result_code = 0, Miss, Safe

result_code=0
result_msg="RDS Backup Check: You have a backup strategy."

dbinstances_size=`aws rds describe-db-instances \--query 'DBInstances[*]' \--output text | tr '\t' '\n'  | wc -l`

if [ "$dbinstances_size" -eq "0" ];then
  result_msg="RDS Backup Check: You don't have RDS service."
else
  check_result=`aws rds describe-db-instances \--query 'DBInstances[*].[BackupRetentionPeriod]' \--output text | tr '\t' '\n' | grep -v '0' | wc -l`
  if [ "$check_result" -eq "0" ];then
    result_code=1
    result_msg="RDS Backup Check: You do NOT have a backup strategy."
  fi
fi

echo $result_code','$result_msg >> /tmp/check_result.log

printf '%s' $result_msg
printf '\n'