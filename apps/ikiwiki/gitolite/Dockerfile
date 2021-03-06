FROM debian:testing
LABEL maintainer Caoimhe Chaos <caoimhechaos@protonmail.com>

ENV DEBIAN_FRONTEND noninteractive
RUN adduser --system --shell /bin/bash --gecos 'Git access' \
    --home /var/lib/git --no-create-home --group --disabled-password git
RUN apt-get -q -y update && apt-get -q -y -o Dpkg::Options::=--force-confdef \
    -o Dpkg::Options::=--force-confold --purge install gitolite3 \
    openssh-server openssh-client libxml-writer-perl libtext-csv-perl \
    libtext-csv-xs-perl imagemagick libimage-magick-perl ikiwiki

RUN install -o git -g git -m 0755 -d /var/lib/git /var/lib/git/.gitolite
COPY run-gitolite.sh /usr/local/bin/run-gitolite.sh
RUN chmod 0555 /usr/local/bin/run-gitolite.sh

RUN ["/usr/sbin/adduser", "git", "www-data"]
RUN ["/usr/sbin/adduser", "www-data", "git"]

USER root
EXPOSE 22/tcp
VOLUME ["/import", "/secrets", "/var/lib/git", "/srv/www", "/etc/ikiwiki"]
CMD ["/bin/sh", "/usr/local/bin/run-gitolite.sh"]
