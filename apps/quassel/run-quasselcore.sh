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
set -e

die () {
       echo "$@" 1>&2
       exit 1
}

test -f /secrets/cacert.pem || die "Error: No CA certificate found at /secrets/cacert.pem"
test -f /secrets/client.crt || die "Error: No client certificate found at /secrets/client.crt"
test -f /secrets/client.key || die "Error: No client key found at /secrets/client.key"
test -f /secrets/quasselCert.pem || die "Error: No Quassel certificate bundle found at /secrets/quasselCert.pem"

kviator --kvstore=etcd --client=$LOCKSERV --ca-cert=/secrets/cacert.pem	\
	--client-cert=/secrets/client.crt				\
	--client-key=/secrets/client.key				\
	get /config/service/quassel/quasselcore.conf >			\
	/var/lib/quassel/quasselcore.conf
chown quassel:quassel /var/lib/quassel/quasselcore.conf
chmod 0440 /var/lib/quassel/quasselcore.conf
install -o quassel -g quassel -m 0440 /secrets/quasselCert.pem	\
	/var/lib/quassel/quasselCert.pem

exec quasselcore -c /var/lib/quassel --oidentd --loglevel=Info		\
	--port=4242 --logfile=/var/log/quassel/core.log 
