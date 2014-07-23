#!/bin/sh
/usr/bin/install -o approx -g approx -m 0755 -d /srv/approx/cache
ls -la /srv/approx/cache
/usr/sbin/rsyslogd
usermod -s /bin/bash "$SETUID_USER"
exec su "$SETUID_USER" -c "exec /usr/bin/micro-inetd $APPROX_PORT /usr/sbin/approx"
