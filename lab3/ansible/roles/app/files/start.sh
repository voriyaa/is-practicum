#!/bin/bash
cd "$(dirname "$0")" || exit 1

set -a
. ./app.env
set +a

if [ -f app.pid ]; then
    PID=$(cat app.pid)
    kill "$PID" 2>/dev/null
    while kill -0 "$PID" 2>/dev/null; do
        sleep 0.2
    done
fi

runuser -u app -- venv/bin/gunicorn --daemon --pid "$PWD/app.pid" --bind "0.0.0.0:$APP_PORT" \
    --access-logfile "$PWD/app.log" --error-logfile "$PWD/app.log" app:app
