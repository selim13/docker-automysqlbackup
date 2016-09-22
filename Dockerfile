FROM alpine:latest

MAINTAINER Dmitry Seleznyov <selim013@gmail.com>

RUN apk add --no-cache bash mysql-client

# Install go-cron
WORKDIR /tmp
ENV GOPATH=/tmp/golang
RUN apk add --no-cache --virtual .build-deps git make go \
    && git clone https://github.com/odise/go-cron.git \
    && cd go-cron \
    && go get github.com/odise/go-cron \
    && make \
    && cp out/linux/go-cron /usr/local/bin \
    && chmod u+x /usr/local/bin/go-cron \
    && cd /tmp \
    && rm -rf golang go-cron \
    && apk del .build-deps

COPY start.sh /usr/local/bin
COPY automysqlbackup /usr/local/bin

RUN chmod +x /usr/local/bin/automysqlbackup /usr/local/bin/start.sh

RUN mkdir -p /etc/default

VOLUME /backup
WORKDIR /backup

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