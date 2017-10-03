#!/bin/sh
/usr/bin/install -o approx -g approx -m 0755 -d /srv/approx/cache
/usr/sbin/rsyslogd
usermod -s /bin/bash "$SETUID_USER"
echo "$APPROX_PORT stream tcp nowait $SETUID_USER /usr/sbin/approx" > /etc/inetd.conf
exec su "$SETUID_USER" -c "exec /usr/sbin/inetd -i /etc/inetd.conf"
