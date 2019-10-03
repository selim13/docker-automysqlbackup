#!/bin/bash

echo
echo Running tests
echo

automysqlbackup
[[ -z `find -type f -size +1b -name '*testdb*.gz'` ]] && exit 1

echo
echo Testing finished
echo

exit 0