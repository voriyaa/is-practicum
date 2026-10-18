#!/bin/bash

DIR=$(cd "$(dirname "$0")" && pwd)
PID_FILE="$DIR/monitor.pid"

is_running() {
    [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null
}

collect() {
    FILE="$DIR/system_report_$(date +%F).csv"
    if [ ! -f "$FILE" ]; then
        echo "timestamp;all_memory;free_memory;%memory_used;%cpu_used;%disk_used;load_average_1m" > "$FILE"
    fi

    MEM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')
    MEM_FREE=$(free -m | awk '/Mem:/ {print $7}')
    MEM_USED=$(( 100 * (MEM_TOTAL - MEM_FREE) / MEM_TOTAL ))
    CPU_USED=$(vmstat 1 2 | tail -1 | awk '{print 100 - $15}')
    DISK_USED=$(df / | awk 'NR == 2 {print $5}' | tr -d '%')
    LOAD=$(cut -d ' ' -f 1 /proc/loadavg)

    echo "$(date "+%Y-%m-%d %H:%M:%S");$MEM_TOTAL;$MEM_FREE;$MEM_USED;$CPU_USED;$DISK_USED;$LOAD" >> "$FILE"
}

case "$1" in
    START)
        if is_running; then
            echo "Already running, PID $(cat "$PID_FILE")"
            exit 1
        fi
        nohup "$0" RUN > /dev/null 2>&1 &
        echo $! > "$PID_FILE"
        echo "Started, PID $!"
        ;;
    RUN)
        while true; do
            collect
            sleep 600
        done
        ;;
    STATUS)
        if is_running; then
            echo "Running, PID $(cat "$PID_FILE")"
        else
            echo "Not running"
        fi
        ;;
    STOP)
        if is_running; then
            kill "$(cat "$PID_FILE")"
            echo "Stopped, PID $(cat "$PID_FILE")"
        else
            echo "Not running"
        fi
        rm -f "$PID_FILE"
        ;;
    *)
        echo "Usage: $0 START|STOP|STATUS"
        exit 1
        ;;
esac
