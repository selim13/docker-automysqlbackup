FROM alpine:latest

MAINTAINER Dmitry Seleznyov <selim013@gmail.com>

RUN apk add --no-cache bash mysql-client

COPY start.sh /usr/local/bin
COPY automysqlbackup /usr/local/bin

RUN chmod +x /usr/local/bin/automysqlbackup /usr/local/bin/start.sh

RUN mkdir -p /etc/default

VOLUME /backup

ENV USERNAME=           \
    PASSWORD=           \
    DBHOST=localhost    \
    DBNAMES=all         \
    BACKUPDIR="/backup" \
    MDBNAMES=           \
    DBEXCLUDE=""        \
    CREATE_DATABASE=yes \
    SEPDIR=yes          \
    DOWEEKLY=6          \
    COMP=gzip           \
    COMMCOMP=no         \
    LATEST=no           \
    MAX_ALLOWED_PACKET= \
    SOCKET=             \
    PREBACKUP=          \
    POSTBACKUP=         \
    ROUTINES=yes        \
    CRON_SCHEDULE=

CMD ["start.sh"]