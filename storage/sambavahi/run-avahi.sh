#!/bin/sh

dbus-daemon --system --fork
exec /usr/bin/dumb-init /usr/sbin/avahi-daemon
