FROM debian:jessie
MAINTAINER Caoimhe Chaos <caoimhechaos@protonmail.com>

RUN apt-get update
RUN apt-get -q -y -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold --purge install gdnsd

EXPOSE 53/tcp 53/udp
VOLUME ["/dns"]

CMD ["/usr/sbin/gdnsd", "-fx", "-c", "/dns", "start"]
