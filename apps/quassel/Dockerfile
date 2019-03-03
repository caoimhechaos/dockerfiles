FROM alpine:3.9
LABEL maintainer Caoimhe Chaos <caoimhechaos@protonmail.com>

COPY run-quasselcore.sh /usr/bin/run-quasselcore.sh

RUN apk --update add git quassel-core qt-postgresql

USER quassel
EXPOSE 4242/tcp
VOLUME ["/secret", "/var/log/quassel", "/var/lib/quassel"]
ENTRYPOINT ["/bin/sh", "/usr/bin/run-quasselcore.sh"]
