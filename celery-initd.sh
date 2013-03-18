#!/sbin/runscript
# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-servers/uwsgi/files/uwsgi.initd,v 1.1 2011/05/31 19:49:07 maksbotan Exp $

APPNAME="jaws"
APPROOT=/var/www/${APPNAME}
APPPATH=${APPROOT}/app
VENV=${APPROOT}/env/bin/activate
SUPERVISORD=${APPROOT}/env/bin/supervisord
SUPERVISORD_CONFIG=${APPROOT}/conf/supervisor.ini
PIDPATH=/var/run/supervisord
PIDFILE="${PIDPATH}/${APPNAME}.pid"

extra_started_commands="reload"

# do we need this?
depend() {
        need net
}

start() {
        source ${VENV}
        ebegin "Starting supervisord for ${APPNAME}"
            if [ ! -d ${PIDPATH} ];then
                mkdir ${PIDPATH} && chmod 777 ${PIDPATH}
            fi

            ${SUPERVISORD} -d ${APPPATH} -c ${SUPERVISORD_CONFIG} --pidfile "${PIDFILE}"
                eend $?
}

stop() {
        ebegin "Stopping supervisord for ${APPNAME}"
            kill -TERM $(cat ${PIDFILE})
                eend $?
}

reload() {
        ebegin "Reloading supervisord for ${APPNAME}"
            kill -HUP $(cat ${PIDFILE})
}


