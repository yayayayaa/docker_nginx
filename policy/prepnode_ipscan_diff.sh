#!/bin/sh

true > /etc/nginx/policy/dynamic_ips_check
for IP in `curl -s ${CHANNEL_MANAGE_DATA_URL} -d '{"jsonrpc" : "2.0", "method": "rep_getList", "id": 1234 }' |jq '.' | awk '/target/' | awk -F: '{print$2}' | sed s/\"//g`
do
   echo "allow $IP;" >> /etc/nginx/policy/dynamic_ips_check
done


if [ "diff --brief /etc/nginx/conf.d/prepnode_dynamic_ips.conf /etc/nginx/policy/dynamic_ips_check" ]; then
    cp /etc/nginx/policy/dynamic_ips_check /etc/nginx/conf.d/prepnode_dynamic_ips.conf
fi
