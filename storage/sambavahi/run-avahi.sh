#!/bin/sh

if test x"$SERVICE_NAME" = x
then
	sed -i -e "s/@HOSTNAME@/%h/g" /etc/avahi/timemachine.service.in
else
	sed -i -e "s/@HOSTNAME@/${SERVICE_NAME}/g" /etc/avahi/timemachine.service.in
fi

for dir in /export/tm-*
do
	bn=`basename "$dir"`
	cat /etc/avahi/timemachine.service.in | sed -e "s/@VOLUME@/${bn}/g" > \
		/etc/avahi/services/timemachine-${bn}.service
done

dbus-daemon --system --fork
exec /usr/bin/dumb-init /usr/sbin/avahi-daemon
