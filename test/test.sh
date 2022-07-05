#!/usr/bin/env bash

BACKUPS_DIR="$1"

DBFILE=$(sudo find $BACKUPS_DIR -type f -size +1b -name '*testdb*.gz')
echo FILE: $DBFILE
[ "$DBFILE" != "" ] || { echo "::error::Backups not created" && exit 1; }
echo GZ
zgrep ignoretable "$DBFILE" && { echo "::error::Ignored table found in the backup" && exit 1; } || true