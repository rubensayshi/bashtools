#!/bin/sh

# 
# simple script to daemonize bitcoind
# 

set -e

PIDPATH="/var/run/bitcoind"

BASEPATH="/usr/bin" # SET TO directory where script is found
DAEMON="${BASEPATH}/bitcoind"
DAEMON_OPTS="" # SET TO whatever arguments you need

CHUID="user:user" # SET TO user:group you want to run the process
NAME="bitcoind" # SET TO unique name if you copy/paste this script to run multiple instances of this script
PIDFILE="${PIDPATH}/${NAME}.pid"

DAEMON_OPTS="${DAEMON_OPTS}"

export PATH="${PATH:+$PATH:}/usr/sbin:/sbin"

case "$1" in
  start)
        echo -n "Starting daemon: ${NAME}"
        if [ ! -d ${PIDPATH} ];then
            mkdir ${PIDPATH} && chmod 777 ${PIDPATH}
        fi
        
        start-stop-daemon --background --chuid $CHUID --make-pidfile --start --quiet --pidfile $PIDFILE --exec $DAEMON -- $DAEMON_OPTS
        echo "."
	;;
  stop)
        echo -n "Stopping daemon: ${NAME}"
    	start-stop-daemon --stop --quiet --oknodo --retry=TERM/30/KILL/5 --pidfile $PIDFILE
        echo "."
	;;
  restart)
        echo -n "Restarting daemon: ${NAME}"
    	start-stop-daemon --stop --quiet --oknodo --retry=TERM/30/KILL/5 --pidfile $PIDFILE
    	start-stop-daemon --background --chuid $CHUID --make-pidfile --start --quiet --pidfile $PIDFILE --exec $DAEMON -- $DAEMON_OPTS
	    echo "."
	;;

  *)
	    echo "Usage: ${1} {start|stop|restart}"
	    exit 1
	;;
esac

exit 0
