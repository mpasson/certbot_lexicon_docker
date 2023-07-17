#!/bin/bash
ip=$(dig +short myip.opendns.com @resolver1.opendns.com)
ip_registered=$(lexicon $PROVIDER list $DOMAIN A --output JSON | jq .[0] | jq -r .content)
if [ "$ip" = "$ip_registered" ]; then
        echo 'IP correct, nothing done'
else
        echo 'IP different, updating'
    lexicon $PROVIDER update $DOMAIN A --content $ip --name=$DOMAIN
    lexicon $PROVIDER update $DOMAIN A --content $ip --name='*'
fi
