# Docker AutoMySQLBackup

A lightweight image for creating and managing scheduled MySQL backups.
Runs a slightly modified [AutoMySQLBackup](https://sourceforge.net/projects/automysqlbackup/) utility.

## Supported tags and respective `Dockerfile` links

- [`2.7.0 2.7.0-mysql8.0 latest` (_Dockerfile_)](https://github.com/selim13/docker-automysqlbackup/blob/v2.7.0/Dockerfile), main image with mysql8 client
- [`2.7.0-mysql5.7` (_Dockerfile_)](https://github.com/selim13/docker-automysqlbackup/blob/v2.7.0/Dockerfile.mysql57), version with mysql5.7 client

## Version

This image uses AutoMySQLBackup 2.5 from Debian Linux source repository as a base, branched at `2.6+debian.4-1` tag.
Original source can be cloned from `git://anonscm.debian.org/users/zigo/automysqlbackup.git` or taken at the
appropriate [Debian package](https://packages.debian.org/sid/automysqlbackup) page.

Custom modifications:

- passed logging to stdout/stderr
- removed error logs mailing code
- made default configuration more suitable for docker container

# Image usage

Let's create a bridge network and start a MySQL container as an example.

```console
docker network create dbtest
docker run --name some-mysql --network dbtest \
    -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:latest
```

For the basic one-shot backup, you can run a container like this:

```console
docker run --network dbtest \
    -v '/var/lib/automysqlbackup:/backup' \
    -e DBHOST=some-mysql \
    -e DBNAMES=all \
    -e USERNAME=root \
    -e PASSWORD=my-secret-pw \
    -e DBNAMES=all \
    automysqlbackup:2.7.0
```

Container will create dumps of all datebases from MySQL inside `/var/lib/automysqlbackup` directory and exit.

To run container in a scheduled mode, populate `CRON_SCHEDULE` environment variable with a cron expression.

```console
docker run --network dbtest \
    -v '/var/lib/automysqlbackup:/backup' \
    -e DBHOST=some-mysql \
    -e DBNAMES=all \
    -e USERNAME=root \
    -e PASSWORD=my-secret-pw \
    -e DBNAMES=all \
    -e CRON_SCHEDULE="0 0 * * *" \
    automysqlbackup:2.7.0
```

Instead of passing environment variables though docker, you can also mount a file with their declarations
as volume. See `defaults` file in this image's git repository for the example.

```console
docker run --network dbtest \
    -v '/var/lib/automysqlbackup:/backup' \
    -v '/etc/default/automysqlbackup:/etc/default/automysqlbackup:ro' \
    automysqlbackup:2.7.0
```

# Usage with docker-compose

For the example of using this image with docker-compose, see [docker-compose.yml](https://github.com/selim13/docker-automysqlbackup/blob/master/docker-compose.yml) file in the image's repository.

Quick tips:

- You can call `automysqlbackup` binary directly for the manual backup: `docker-compose exec mysqlbackup automysqlbackup`
- Use only YAML dictionary for passing CRON_SCHEDULE environment variable `CRON_SCHEDULE: "0 0 * * *"`
  as YAML sequence `- CRON_SCHEDULE="0 * * * *"` will preserve quotes breaking go-cron (Issue #1).

## Environment variables

- **CRON_SCHEDULE**\
  If set to cron expression, container will start a cron daemon for scheduled backups.

- **USERNAME**\
  Username to access the MySQL server.

- **PASSWORD**\
  Password to access the MySQL server.

- **DBHOST**\
  Host name (or IP address) of MySQL server.

- **DBPORT**\
  Port of MySQL server.

- **DBNAMES**\
  List of space separated database names for Daily/Weekly Backup. Set to `all` for all databases.\
  Default value: `all`

- **BACKUPDIR**\
  Backup directory location.
  Folders inside this one will be created (daily, weekly, etc.), and the subfolders will be database names.\
  Default value: `/backup`

- **MDBNAMES**\
  List of space separated database names for Monthly Backups.\
  Will mirror DBNAMES if DBNAMES set to `all`.

- **DBEXCLUDE**\
  List of DBNAMES to **exclude** if DBNAMES are set to all (must be in " quotes).

- **IGNORE_TABLES**\
  List of space separated table names in a format of `db_name.tbl_name` to exclude from backup (must be in " quotes).

- **CREATE_DATABASE**\
  Include CREATE DATABASE in backup?\
  Default value: `yes`

- **SEPDIR**\
  Separate backup directory and file for each DB? (yes or no).\
  Default value: `yes`

- **DOWEEKLY**\
  Which day do you want weekly backups? (1 to 7 where 1 is Monday).\
  Default value: `6`

- **COMP**\
  Choose Compression type. (gzip or bzip2)\
  Default value: `gzip`

- **COMMCOMP**\
  Compress communications between backup server and MySQL server?\
  Default value: `no`

- **LATEST**\
  Additionally keep a copy of the most recent backup in a seperate directory.\
  Default value: `no`

- **MAX_ALLOWED_PACKET**\
  The maximum size of the buffer for client/server communication. e.g. 16MB (maximum is 1GB)

- **SOCKET**\
  For connections to localhost. Sometimes the Unix socket file must be specified.

- **PREBACKUP**\
  Command to run before backups

- **POSTBACKUP**\
  Command run after backups

- **ROUTINES**\
  Backup of stored procedures and routines\
  Default value: `yes`

- **EXTRA_OPTS**\
  Pass any arbitrary flags to mysqldump, e.g. `--single-transaction`.

- **USER_ID**
  Run the backup process from the specified user id. Allows matching backup files permissions with the host's user.\
  Default value: `1` (root).

- **GROUP_ID**
  Run the backup process from the specified group id. Allows matching backup files permissions with the host's group.\
  If empty, matches USER_ID.

## Docker Secrets

As an alternative to passing sensitive information via environment variables, `_FILE` may be appended to some of the previously listed environment variables, causing the initialization script to load the values for those variables from files present in the container. In particular, this can be used to load passwords from Docker secrets stored in `/run/secrets/<secret_name>` files. For example:

```console
docker run --name automysqlbackup -e USERNAME=root -e PASSWORD_FILE=/run/secrets/mysql_root_password automysqlbackup
```

Currently, this is only supported for `USERNAME` and `PASSWORD`.

## FAQ

- **Will you add support for AutoMySQLBackup 3?**\
  No. AutoMySQLBackup 3 was a complete rewrite of the script with much higher
  complexity but was abandoned in 2011 before it released. There are multiple
  repositories which try to support it by fixing bugs and ensuring compatibility
  with newer MySQL versions but I don't have time to track changes in those
  to properly support docker image.

- **Can you add CONFIG\_\* option**\
  Those options appeared in AutoMySQLBackup 3. See the above question.

## License

Similar to the original automysqlbackup script, all sources for this image
are licensed under [GPL-2.0](./LICENSE.txt).
