#!/bin/sh
#
# Set up the list of SSH keys for borg and launch sshd.

set -e

install -o root -g root -m 0755 -d /run/sshd

for type in ecdsa ed25519 rsa
do
	test -f /etc/ssh/ssh_host_${type}_key || ssh-keygen -t $type -N '' -f /etc/ssh/ssh_host_${type}_key
done

install -o borg -g borg -m 0700 -d /srv/backup/.ssh

orig_umask="$(umask)"

umask 077
cat /ssh-keys/* > /srv/backup/.ssh/authorized_keys
chown borg:borg /srv/backup/.ssh/authorized_keys
chmod 0600 /srv/backup/.ssh/authorized_keys

umask "$orig_umask"

exec /usr/bin/dumb-init /usr/sbin/sshd -eD
