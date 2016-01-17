#! /bin/sh
### BEGIN INIT INFO
# Provides:          rpi-shutdown
# Required-Start:    $syslog
# Required-Stop:
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Shutdown RPi gracefully when wall wart is yanked.
### END INIT INFO

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/bin

. /lib/lsb/init-functions
SCRIPT=/root/shutdown.py
PIDFILE=/var/run/shutdown.pid

start() {
    log_daemon_msg "Starting graceful shutdown service"
    $SCRIPT &
    pid=$!
    status=$?
    if [ "$status" != "0" ]; then
        log_failure_msg "ouch"
    else
        echo $pid > $PIDFILE
    fi
    echo $!
}

stop() {
    log_daemon_msg "Stopping graceful shutdown service"
    if [ -f $PIDFILE ]; then
        kill -9 `cat $PIDFILE`
        rm -f $PIDFILE
    fi
}

case "$1" in
  start)
    start
    exit 0
    ;;
  stop)
    stop
    exit 0
    ;;
  restart)
    stop
    start
    exit 0
    ;;
  *)
    echo "Usage: /etc/init.d/rpi-shutdown.sh {start|stop}"
    exit 1
    ;;
esac
