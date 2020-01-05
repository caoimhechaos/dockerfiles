FROM alpine:3.11
LABEL maintainer="Caoimhe Chaos <caoimhechaos@protonmail.com>"

RUN ["/sbin/apk", "--update", "add", "avahi", "dbus", "dumb-init"]
RUN rm -f /etc/avahi/services/*
COPY timemachine.service /etc/avahi/timemachine.service.in
COPY run-avahi.sh /usr/local/bin/run-avahi.sh

EXPOSE 5353/tcp 5353/udp
USER root
ENTRYPOINT ["/bin/sh", "/usr/local/bin/run-avahi.sh"]
