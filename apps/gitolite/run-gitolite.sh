#!/bin/sh
#
# Copyright (c) 2017, Caoimhe Chaos <caoimhechaos@protonmail.com>.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# * Redistributions of source code must retain the above copyright notice,
#   this list of conditions and the following disclaimer.
#
# * Redistributions in binary form must reproduce the above copyright
#   notice, this list of conditions and the following disclaimer in the
#   documentation and/or other materials provided with the distribution.
#
# * Neither the name of Ancient Solutions nor the names of its
#   contributors may be used to endorse or promote products derived from
#   this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

set -e

install -o root -g root -m 0755 -d /run/sshd
chown git:git /var/lib/git
install -o git -g git -m 0700 -d /var/lib/git/.gitolite	\
	/var/lib/git/.gitolite/logs

# If we don't have a gitolite config yet but there is an admin key under
# /import, set up gitolite with that key being the new admin.
if [ ! -e /var/lib/git/.gitolite/conf/gitolite.conf ] &&	\
	[ -e /import/admin.pub ]
then
	su - git -c 'gitolite setup -pk /import/admin.pub'
fi

install -o root -g root -m 0755 -d /etc/ssh
for f in /secrets/ssh_host_*
do
	install -o root -g root -m 0600 "$f" "/etc/ssh/$(basename "$f")"
done

exec /usr/bin/dumb-init /usr/sbin/sshd -eD
