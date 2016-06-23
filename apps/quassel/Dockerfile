FROM caoimhechaos/ancientsolutions-base:testing
MAINTAINER Caoimhe Chaos <caoimhechaos@protonmail.com>

COPY run-quasselcore.sh /usr/bin/run-quasselcore.sh

RUN apt-get update
RUN apt-get -q -y -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold --purge install quassel-core libqt5sql5-psql etcd

USER quasselcore
EXPOSE 4242/tcp
VOLUME ["/secret", "/var/log/quassel", "/var/lib/quassel"]
ENTRYPOINT ["/bin/sh", "/usr/bin/run-quasselcore.sh"]
