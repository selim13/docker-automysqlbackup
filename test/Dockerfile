FROM debian:buster-slim
LABEL maintainer="selim013@gmail.com"

RUN apt-get update && apt-get install -y --no-install-recommends git && rm -rf /var/lib/apt/lists/*

ENV GIT_SSL_NO_VERIFY=1
RUN git clone https://github.com/bats-core/bats-core.git && cd bats-core && ./install.sh /usr/local

COPY automysqlbackup.bats /usr/local/bin/
COPY wait_to_finish.sh /usr/local/bin/