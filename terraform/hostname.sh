#!/usr/bin/sh

IP=`hostname -i`

echo "{\"ip\":\"$IP/32\"}"
