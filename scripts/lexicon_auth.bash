#!/usr/bin/env bash
#

set -euf -o pipefail

PROVIDER_UPDATE_DELAY=120

# To be invoked via Certbot's --manual-auth-hook
function auth {
    lexicon "${PROVIDER}" \
    create "${CERTBOT_DOMAIN}" TXT --name "_acme-challenge.${CERTBOT_DOMAIN}" --content "${CERTBOT_VALIDATION}" --ttl 60

    sleep "${PROVIDER_UPDATE_DELAY}"
}

# To be invoked via Certbot's --manual-cleanup-hook
function cleanup {
    lexicon "${PROVIDER}" \
    delete "${CERTBOT_DOMAIN}" TXT --name "_acme-challenge.${CERTBOT_DOMAIN}" --content "${CERTBOT_VALIDATION}"
}

function list {
    lexicon "${PROVIDER}" list "${DOMAIN}" A
}


HANDLER=$1; shift;
if [ -n "$(type -t $HANDLER)" ] && [ "$(type -t $HANDLER)" = function ]; then
  $HANDLER "$@"
fi