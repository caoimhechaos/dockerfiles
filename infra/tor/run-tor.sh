#!/bin/sh

set -e
umask 077

myip="$(/bin/hostname -i)"
sed -e"s/@ADDRESS@/${myip}/g" /etc/tor/torrc.in > /etc/tor/torrc
for f in /etc/tor/conf.d/*
do
    test -f "$f" && sed -e"s/@ADDRESS@/${myip}/g" "$f" >> /etc/tor/torrc
done

cat /etc/tor/torrc

exec /usr/bin/tor "$@"
