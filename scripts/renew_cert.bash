#!/usr/bin/env bash
#

certbot renew $OPTIONS

cat /etc/letsencrypt/live/$DOMAIN/privkey.pem \
     /etc/letsencrypt/live/$DOMAIN/cert.pem \
     /etc/letsencrypt/live/$DOMAIN/fullchain.pem > /etc/letsencrypt/live/$DOMAIN/haproxy.pem