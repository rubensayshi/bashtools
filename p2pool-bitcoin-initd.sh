#!/bin/sh

# 
# simple script to daemonize p2pool
# you can copy/paste this script if you want to run multiple instances of p2pool for different currencies, MAKE SURE TO CHANGE NAME= in that case!
# output is logged to $LOGPATH/$NAME.log
# 

set -e

PIDPATH="/var/run/p2pool"
LOGPATH="/var/log/p2pool"

P2POOL="/home/user/p2pool" # SET TO directory where p2pool script is found
DAEMON="${P2POOL}/run_p2pool.py"
DAEMON_OPTS="bitcoind --give-author 0 --irc-announce --max-conns 1000000 --fee 0" # SET TO whatever arguments you need

CHUID="user:user" # SET TO user:group you want to run the process
NAME="bitcoind" # SET TO unique name if you copy/paste this script to run multiple instances of p2pool
PIDFILE="${PIDPATH}/${NAME}.pid"
LOGFILE="${LOGPATH}/${NAME}.log"

DAEMON_OPTS="${DAEMON_OPTS} --logfile ${LOGFILE}"

export PATH="${PATH:+$PATH:}/usr/sbin:/sbin"

case "$1" in
  start)
        echo -n "Starting daemon: ${NAME}"
        if [ ! -d ${PIDPATH} ];then
            mkdir ${PIDPATH} && chmod 777 ${PIDPATH}
        fi
        if [ ! -d ${LOGPATH} ];then
            mkdir ${LOGPATH} && chmod 777 ${LOGPATH}
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
	    echo "Usage: "$1" {start|stop|restart}"
	    exit 1
	;;
esac

exit 0
