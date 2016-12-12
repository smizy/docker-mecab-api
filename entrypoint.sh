#!/bin/bash

set -eo pipefail

if [ "$1" == "gunicorn" ]; then
    shift
    exec su-exec mecab gunicorn --access-logfile -  "$@"
fi

exec "$@"