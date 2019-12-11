#!/usr/bin/sh

#IP=`hostname -i`
IP=`curl http://169.254.169.254/latest/meta-data/local-ipv4`

echo "{\"ip\":\"$IP\"}"
