# Build
FROM golang:1.9 as builder

RUN go get -d -v github.com/odise/go-cron
WORKDIR /go/src/github.com/odise/go-cron
RUN CGO_ENABLED=0 GOOS=linux go build -o go-cron bin/go-cron.go

# Package
FROM alpine:3.6
MAINTAINER Dmitry Seleznyov <selim013@gmail.com>

RUN apk add --no-cache mysql-client

COPY --from=builder /go/src/github.com/odise/go-cron/go-cron /usr/local/bin
COPY start.sh /usr/local/bin
COPY automysqlbackup /usr/local/bin

RUN chmod +x /usr/local/bin/go-cron /usr/local/bin/automysqlbackup /usr/local/bin/start.sh

RUN mkdir -p /etc/default

VOLUME /backup
WORKDIR /backup

ENV USERNAME=           \
    PASSWORD=           \
    DBHOST=localhost    \
    DBNAMES=all         \
    DBPORT=3306         \
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