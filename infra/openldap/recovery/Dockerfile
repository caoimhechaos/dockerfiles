FROM alpine:3.6
LABEL maintainer "Caoimhe Chaos <caoimhechaos@protonmail.com>"

RUN apk --update add db-utils

COPY recovery.sh /usr/local/bin/recovery.sh
VOLUME ["/var/lib/openldap/openldap-data"]

ENTRYPOINT ["/bin/sh", "/usr/local/bin/recovery.sh"]
