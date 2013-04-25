#!/sbin/runscript
# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-servers/uwsgi/files/uwsgi.initd,v 1.1 2011/05/31 19:49:07 maksbotan Exp $

PROGNAME=${SVCNAME}

UWSGI_EXEC=/usr/bin/uwsgi
PIDPATH=/var/run/uwsgi
PIDFILE="${PIDPATH}/${PROGNAME}.pid"

extra_started_commands="reload"

depend() {
        need net
}

start() {
        ebegin "Starting uWSGI application ${PROGNAME}"
            if [ ! -d ${PIDPATH} ];then
                mkdir ${PIDPATH} && chmod 777 ${PIDPATH}
            fi

            ${UWSGI_EXEC} --daemonize /var/log/uwsgi/emperor.log --emperor '/var/www/*/conf/uwsgi.ini' --pidfile "${PIDFILE}" ${UWSGI_EXTRA_OPTIONS}
                eend $?
}

stop() {
        ebegin "Stopping uWSGI application ${PROGNAME}"
            kill -9 $(cat ${PIDFILE})
                eend $?
}

reload() {
        ebegin "Reloading uWSGI application ${PROGNAME}"
            ${UWSGI_EXEC} --reload "${PIDFILE}"
}


