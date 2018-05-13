#!/bin/sh
#
# Copy config file into place and launch autopostgresqlbackup.
#

set -e

if [ -z "$CONFIG" ] && [ -n "$1" ]
then
	CONFIG="$1"
fi

if [ -z "$CONFIG" ]
then
	echo "You forgot to specify the CONFIG environment variable." 1>&2
	exit 1
fi

install -o root -g root -m 0644 "$CONFIG" /etc/default/autopostgresqlbackup
install -o pg-backup -g pg-backup -m 0400 /backup/.pgpass "$HOME/.pgpass"

exec /usr/sbin/autopostgresqlbackup
