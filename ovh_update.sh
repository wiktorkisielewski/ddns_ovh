#!/bin/bash

ZONE=""
SUB_DOMAIN=""
RECORD_ID=""

IP=$(./ddns.sh)

OVH_CONSUMER_KEY=$OVH_CK
OVH_APP_KEY=$OVH_AK
OVH_APP_SECRET=$OVH_AS

TIME=$(curl -s https://ca.api.ovh.com/1.0/auth/time)
HTTP_METHOD="PUT"
HTTP_URL="https://ca.api.ovh.com/1.0/domain/zone/$ZONE/record/$RECORD_ID"
HTTP_BODY='{"subDomain":"'$SUB_DOMAIN'","target":"'$IP'","ttl":0}'

CLEAR_SIGN="$OVH_APP_SECRET+$OVH_CONSUMER_KEY+$HTTP_METHOD+$HTTP_URL+$HTTP_BODY+$TIME"
SIG='$1$'$(echo -n $CLEAR_SIGN | openssl dgst -sha1 | sed -e 's/^.* //')

curl $HTTP_URL \
    -X PUT \
    -H "Content-Type:application/json;charset=utf-8"  \
    -H "X-Ovh-Application:$OVH_APP_KEY" \
    -H "X-Ovh-Timestamp:$TIME" \
    -H "X-Ovh-Signature:$SIG" \
    -H "X-Ovh-Consumer:$OVH_CONSUMER_KEY" \
    --data $HTTP_BODY
