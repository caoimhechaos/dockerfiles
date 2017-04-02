#!/bin/sh
#
# Copyright (c) 2017, Caoimhe Chaos <caoimhechaos@protonmail.com>.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:
#
# * Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.
#
# * Redistributions in binary form must reproduce the above copyright notice, this
#   list of conditions and the following disclaimer in the documentation and/or
#  other materials provided with the distribution.
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

if [ x"$2" != x ]
then
	ETCD_DOMAIN="$1"
	shift
fi

if [ x"$1" != x ]
then
	ETCD_KEY="$1"
fi

if [ x"$ETCD_DOMAIN" = x ]
then
	echo "ETCD_DOMAIN is not set and not given as argument." 1>&2
	exit 1
fi

if [ x"$ETCD_KEY" = x ]
then
	echo "ETCD_KEY is not set and not given as argument." 1>&2
	exit 1
fi

cd /etc/prometheus

/usr/bin/prometheus &

if [ -f /secrets/etcd-ca.crt ]
then
	ETCDCTL_FLAGS="$ETCDCTL_FLAGS --ca-file=/secrets/etcd-ca.crt"
fi

if [ -f /secrets/etcd.key ]
then
	ETCDCTL_FLAGS="$ETCDCTL_FLAGS --key-file=/secrets/etcd.key"
fi

if [ -f /secrets/etcd.crt ]
then
	ETCDCTL_FLAGS="$ETCDCTL_FLAGS --cert-file=/secrets/etcd.crt"
fi

while etcdctl -D "$ETCD_DOMAIN" $ETCDCTL_FLAGS watch "$ETCD_KEY"
do
	git pull -r
	pkill -HUP prometheus
done
