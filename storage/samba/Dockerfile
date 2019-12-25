FROM alpine:3.11
LABEL maintainer="Caoimhe Chaos <caoimhechaos@protonmail.com>"

RUN ["/sbin/apk", "--update", "add", "samba", "tracker", "dconf"]
RUN ["/usr/bin/install", "-o", "root", "-g", "root", "-m", "0755", "-d", "/export"]
COPY run-smbd.sh /usr/local/bin/run-smbd.sh

VOLUME ["/export", "/var/lib/samba"]
EXPOSE 137/tcp 138/tcp 139/tcp 445/tcp
USER root
ENTRYPOINT ["/bin/sh", "-x", "/usr/local/bin/run-smbd.sh"]
