#!/bin/bash

while ping -c1 $1 &>/dev/null; do 
    sleep 1
done