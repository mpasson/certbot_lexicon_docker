# Dockerfile for certbot

FROM alpine:3.18

RUN apk add --update --no-cache \
    python3 \
    py3-pip \
    bash \
    nginx \
    nano \
    certbot-nginx \
    bind-tools \
    jq \
    && rm -rf /var/cache/apk/*

RUN pip install dns-lexicon
ENV PATH="$PATH:/opt/" \
    PROVIDER_UPDATE_DELAY=120

COPY ./scripts/* /opt/
RUN chmod +x /opt/*