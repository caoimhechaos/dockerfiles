#!/bin/sh

while :
do
	while read domain nameserver
	do
		perl /dnsutils/axfrfetch.pl "$domain" "$nameserver"
	done < /dns/axfrdomains

	sleep 3600
done
