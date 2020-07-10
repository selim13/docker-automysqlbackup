#!/usr/bin/env bats

DBFILE=`find -type f -size +1b -name '*testdb*.gz'`

@test "Backup files exist " {    
    [[ ! -z "$DBFILE" ]]
    echo $DBFILE
}

@test "Ignored table skipped" {
    run zgrep ignoretable "$DBFILE"
    [ "$status" -eq 1 ]
}
