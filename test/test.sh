#!/usr/bin/env bash

BACKUPS_DIR="$1"

DBFILE=$(sudo find $BACKUPS_DIR -type f -size +1b -name '*testdb*.gz')

[ "$DBFILE" != "" ] || { echo "::error::Backups not created" && exit 1; }
zgrep ignoretable "$DBFILE" && { echo "::error::Ignored table found in the backup" && exit 1; } || true