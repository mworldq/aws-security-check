#!/bin/bash
# test.sh

# Init Result
#echo '' > /tmp/check_result.log
#
## Exec the rules
#for f in ./rules/*.sh ;
#  do
#    [ -x "$f" ] && [ ! -d "$f" ] && "$f" ;
#  done

printf "+++++++++++++++++++++++++++++++++\n"
printf "++++++++++   Summary   ++++++++++\n"
printf "+++++++++++++++++++++++++++++++++\n"
while read line
do
if [ "${line%,*}" = 1 ];then
  echo -e "\033[41;36m ${line#*,} \033[0m"
else
  echo ${line#*,}
fi
done  < /tmp/check_result.log