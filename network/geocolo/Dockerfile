FROM caoimhechaos/ancientsolutions-base:stable
MAINTAINER Caoimhe Chaos <caoimhechaos@protonmail.com>

RUN apt-get update
RUN apt-get -q -y -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold --purge install geocolo-service

RUN ["/usr/bin/install", "-o", "root", "-g", "root", "-m", "0755", "-d", "/etc/geocolo"]
RUN ["/usr/bin/install", "-o", "root", "-g", "root", "-m", "0700", "-d", "/run/geocolo-certs"]

EXPOSE 1234/tcp
VOLUME ["/etc/geocolo", "/run/geocolo-certs"]

CMD ["/usr/bin/geocolo-service", "--config=/etc/geocolo/geocolo.conf", "--listen=[::]:1234"]
