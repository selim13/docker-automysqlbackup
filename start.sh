#!/bin/sh

set -e

if [ "${CRON_SCHEDULE}" ]; then
    exec go-cron -s "0 ${CRON_SCHEDULE}" -- automysqlbackup
else
    exec automysqlbackup
fi
