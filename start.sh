#!/bin/bash

set -e

# usage: file_env VAR [DEFAULT]
#    ie: file_env 'XYZ_DB_PASSWORD' 'example'
# (will allow for "$XYZ_DB_PASSWORD_FILE" to fill in the value of
#  "$XYZ_DB_PASSWORD" from a file, especially for Docker's secrets feature)
file_env() {
        local var="$1"
        local fileVar="${var}_FILE"
        local def="${2:-}"
        if [ "${!var:-}" ] && [ "${!fileVar:-}" ]; then
                echo >&2 "error: both $var and $fileVar are set (but are exclusive)"
                exit 1
        fi
        local val="$def"
        if [ "${!var:-}" ]; then
                val="${!var}"
        elif [ "${!fileVar:-}" ]; then
                val="$(< "${!fileVar}")"
        fi
        export "$var"="$val"
        unset "$fileVar"
}

# Get PASSWORD from PASSWORD_FILE if available
file_env 'PASSWORD'

# Get USERNAME from USERNAME_FILE if availabile
file_env 'USERNAME'

# Select user to run the process
user="root"
if [ "$USER_ID" ] && [ "$USER_ID" != "1" ]; then
        usermod --uid $USER_ID automysqlbackup > /dev/null
        groupmod --gid $USER_ID automysqlbackup

        # make sure we can write to stdout and stderr as user
        chown --dereference automysqlbackup "/proc/$$/fd/1" "/proc/$$/fd/2" || :
        # ignore errors thanks to https://github.com/docker-library/mongo/issues/149

        user="automysqlbackup"
fi

# Select group to run the process
group="$user"
if [ "$GROUP_ID" ]; then
        if [ "$GROUP_ID" == "1" ]; then
                group="root"
        else
                groupmod -g $GROUP_ID automysqlbackup
                group="automysqlbackup"
        fi
fi

if [ "${CRON_SCHEDULE}" ]; then
    exec gosu $user:$group go-cron -s "0 ${CRON_SCHEDULE}" -- automysqlbackup
else
    exec gosu $user:$group bash /usr/local/bin/automysqlbackup
fi
