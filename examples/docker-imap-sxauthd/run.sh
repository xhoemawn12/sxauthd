#!/bin/sh
docker build -t sxauthd-imap .
docker rm -f sxauthd-imap-run
# TODO: should connect to host, but how? 172.17.0.1 doesn't work (no route to host to 443)
docker run \
    -p 127.0.0.1:10000:10000 \
    --restart=always -d \
    -v /run/uwsgi/app/sxauthd/:/run/uwsgi/app/sxauthd/ \
    -v "$HOME/.sx:/root/.sx:ro" \
    -e SX_CLUSTER_INTERNAL_IP=188.40.45.251 -e SX_CLUSTER_EXTERNAL_IP=192.168.108.11 -e SX_CLUSTER_NAME=cliente.ioffice.me -e SX_CLUSTER_PORT=443 \
    --link imaps-ambassador-run:imapserver \
    --name sxauthd-imap-run \
    sxauthd-imap
