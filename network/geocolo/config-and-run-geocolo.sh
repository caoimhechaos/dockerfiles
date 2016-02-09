#!/bin/sh
#
# Copyright (c) 2016 Caoimhe Chaos <caoimhechaos@protonmail.com>,
#                    Ancient Solutions. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# 1. Redistributions  of source code must retain  the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions  in   binary  form  must   reproduce  the  above
#    copyright  notice, this  list  of conditions  and the  following
#    disclaimer in the  documentation and/or other materials provided
#    with the distribution.
#
# THIS  SOFTWARE IS  PROVIDED BY  ANCIENT SOLUTIONS  AND CONTRIBUTORS
# ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO,  THE IMPLIED WARRANTIES OF  MERCHANTABILITY AND FITNESS
# FOR A  PARTICULAR PURPOSE  ARE DISCLAIMED.  IN  NO EVENT  SHALL THE
# FOUNDATION  OR CONTRIBUTORS  BE  LIABLE FOR  ANY DIRECT,  INDIRECT,
# INCIDENTAL,   SPECIAL,    EXEMPLARY,   OR   CONSEQUENTIAL   DAMAGES
# (INCLUDING, BUT NOT LIMITED  TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE,  DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
# STRICT  LIABILITY,  OR  TORT  (INCLUDING NEGLIGENCE  OR  OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
# OF THE POSSIBILITY OF SUCH DAMAGE.
#

cat << EOT > /etc/geocolo/geocolo.conf
user: "${GEOCOLO_DB_USER:=georeader}"
dbname: "${GEOCOLO_DB_NAME:=gis}"
host: "${GEOCOLO_DB_HOST:=localhost}"
port: ${GEOCOLO_DB_PORT:=5432}
password: "${GEOCOLO_DB_PASSWORD:=blahblahblubberblubber}"

geoip_path: "/usr/share/GeoIP/GeoIP.dat"
rfc1918_country: "${GEOCOLO_RFC1918:=CH}"
EOT

for host in $(echo ${ETCD_HOSTS} | sed -e's/,/ /g')
do
	echo "etcd_url: \"${host}\"" >> /etc/geocolo/geocolo.conf
done

if [ -f "/run/geocolo-certs/geocolo.crt" ]
then
	echo "service_certificate: \"/run/geocolo-certs/geocolo.crt\"" >> /etc/geocolo/geocolo.conf
fi

if [ -f "/run/geocolo-certs/geocolo.key" ]
then
	echo "service_key: \"/run/geocolo-certs/geocolo.key\"" >> /etc/geocolo/geocolo.conf
fi

if [ -f "/run/geocolo-certs/ca.crt" ]
then
	echo "ca_certificate: \"/run/geocolo-certs/ca.crt\"" >> /etc/geocolo/geocolo.conf
fi

if [ -n "$GEOCOLO_DB_SSLMODE" ]
then
	echo "sslmode: \"${GEOCOLO_DB_SSLMODE}\"" >> /etc/geocolo/geocolo.conf
fi

exec /usr/bin/geocolo-service --config=/etc/geocolo/geocolo.conf --listen-addr=[::]:1234
