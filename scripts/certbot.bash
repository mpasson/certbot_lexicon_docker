#!/usr/bin/env bash
#

certbot certonly \
     $OPTIONS \
     --manual \
     --force-renewal \
     --email $EMAIL \
     -d $DOMAIN \
     -d *.$DOMAIN \
     --agree-tos \
     --noninteractive \
     --preferred-challenges dns \
     --manual-auth-hook "/opt/lexicon_auth.bash auth" \
     --manual-cleanup-hook "/opt/lexicon_auth.bash cleanup" 

cat /etc/letsencrypt/live/$DOMAIN/privkey.pem \
     /etc/letsencrypt/live/$DOMAIN/cert.pem \
     /etc/letsencrypt/live/$DOMAIN/fullchain.pem > /etc/letsencrypt/live/$DOMAIN/haproxy.pem