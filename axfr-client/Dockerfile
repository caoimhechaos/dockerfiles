FROM caoimhechaos/ancientsolutions-base:latest
MAINTAINER Caoimhe Chaos <caoimhechaos@protonmail.com>

RUN apt-get -q -y -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold --purge install git libfile-slurp-perl libnet-dns-perl perl perl-base

RUN /usr/bin/git clone https://github.com/caoimhechaos/dnsutils/

VOLUME ["/dns"]

COPY ["fetch-regularly.sh", "/root/fetch-regularly.sh"]

CMD ["/bin/sh", "-x", "/root/fetch-regularly.sh"]
