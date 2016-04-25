FROM debian:unstable
MAINTAINER Caoimhe Chaos <caoimhechaos@protonmail.com>

# Tell apt to keep to itself.
ENV DEBIAN_FRONTEND noninteractive
ENV SETUID_USER approx
ENV APPROX_PORT 8080

# Build the sources.list file.
RUN echo "deb http://debian.l.internetputzen.com/debian/ stable main contrib non-free" > /etc/apt/sources.list
RUN echo "deb http://debian.l.internetputzen.com/security/ stable/updates main contrib non-free" >> /etc/apt/sources.list
RUN apt-get -q -y update

# Set up rsyslog.
COPY rsyslog.conf /etc/rsyslog.conf

# Install esmtp so stuff stops installing exim.
RUN apt-get -q -y -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold --purge install esmtp esmtp-run

# Ensure we can write syslogs.
RUN apt-get -q -y -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold --purge install rsyslog rsyslog-relp

# Install approx, esmtp and the inetd to run approx from.
RUN apt-get -q -y -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold --purge install micro-inetd approx bzip2 openbsd-inetd update-inetd

# Configure approx.
COPY approx.conf /etc/approx/approx.conf

# Ensure we have the directories required for the volumes.
RUN /usr/bin/install -o approx -g approx -m 0755 -d /srv/approx/cache

# Install the run script. We have to run 2 commands at all times (launch
# syslog, then start inetd), so we have to use a script.
ADD run-inetd.sh /usr/local/bin/run-inetd.sh

# It's an HTTP server.
EXPOSE 8080/tcp

# Our main purpose will be to run inetd.
CMD /bin/sh /usr/local/bin/run-inetd.sh
