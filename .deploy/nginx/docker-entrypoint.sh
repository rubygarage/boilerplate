#!/bin/sh

set -e

envsubst '$STATIC_PATH' < /etc/nginx/conf.d/templates/default.conf > /etc/nginx/conf.d/default.conf

exec "$@"
