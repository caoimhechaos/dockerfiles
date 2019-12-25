FROM alpine:3.11
LABEL maintainer="Caoimhe Chaos <caoimhechaos@protonmail.com>"

RUN ["/sbin/apk", "--update", "add", "samba"]
COPY run-smbd.sh /usr/local/bin/run-smbd.sh

VOLUME ["/export", "/var/lib/samba"]
USER root
ENTRYPOINT ["/bin/sh", "-x", "/usr/local/bin/run-smbd.sh"]
