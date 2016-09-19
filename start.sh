#!/bin/sh

set -e

if [ "${CRON_SCHEDULE}" ]; then
    echo "${CRON_SCHEDULE} automysqlbackup" > /var/spool/cron/crontabs/root && crond -f -l 0
else
    exec automysqlbackup
fi
