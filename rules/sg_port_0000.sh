#!/bin/bash

# result_code = 0, Miss, Safe
# result_code = 1, Hit, Danger
# result_code = 11, Danger Detail

while read line
do
  if [[ $line == "" || $line == \#* ]] ;then
    continue
  else
    printf "vvvvvvvvvv Execute Check - $(basename $0) with port: ${line} Start: vvvvvvvvvv\n "
    check_result=`aws ec2 describe-security-groups --filters "Name=ip-permission.to-port,Values=${line}" --query 'SecurityGroups[?length(IpPermissions[?ToPort==\`'"${line}"'\` && contains(IpRanges[].CidrIp, \`0.0.0.0/0\`)]) > \`0\`].GroupId' --output text  | tr '\t' '\n' `
    result_code=0
    result_msg="SecurityGroups Check: There are restrictions on your service with Port ${line}  or no service used."
    result_detail=""
    array=(${check_result// / })
    #echo ${#array[*]}
    if [ "${#array[*]}" -gt "0" ];then
      result_code=1
      result_msg="SecurityGroups Check: Your service with Port ${line} is open to the world:"
      result_detail=$check_result
    fi
    echo $result_code','$result_msg >> /tmp/check_result.log
    for dd in $result_detail
    do
      echo '11,'SecurityGroup-ID:$dd >> /tmp/check_result.log
    done
    printf "%s\n" "$result_msg"
    printf "^^^^^^^^^^ Execute Check - $(basename $0) with port: ${line} Completed. ^^^^^^^^^^\n "
  fi
done  < ./sg_port_0000.properties