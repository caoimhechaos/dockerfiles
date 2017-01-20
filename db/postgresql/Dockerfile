FROM caoimhechaos/ancientsolutions-base:stable
MAINTAINER Caoimhe Chaos <caoimhechaos@protonmail.com>

RUN apt-get -q -y update
RUN apt-get -q -y -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold --purge install locales postgresql postgresql-9.4 postgresql-9.4-ip4r postgresql-9.4-pgmemcache postgresql-9.4-plr postgresql-9.4-postgis-2.1 postgresql-9.4-prefix kviator

RUN /usr/bin/pg_dropcluster 9.4 main

RUN sed -i -e "s/^.*en_US.UTF-8/en_US.UTF-8/g" /etc/locale.gen
RUN /usr/sbin/locale-gen

ADD pg_config.sh /usr/local/bin/pg_config.sh

RUN ["/bin/chmod", "0555", "/usr/local/bin/pg_config.sh"]
RUN ["/usr/bin/install", "-o", "postgres", "-g", "postgres", "-m", "2750", "-d", "/var/run/postgresql"]
RUN ["/usr/bin/install", "-o", "postgres", "-g", "postgres", "-m", "2750", "-d", "/var/run/postgresql/9.4-main.pg_stat_tmp"]

EXPOSE 5432/tcp
VOLUME ["/secrets", "/var/lib/postgresql"]
USER postgres

CMD ["/bin/sh", "/usr/local/bin/pg_config.sh"]
