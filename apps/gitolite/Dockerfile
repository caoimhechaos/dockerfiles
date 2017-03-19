FROM alpine:3.5
MAINTAINER Caoimhe Chaos <caoimhechaos@protonmail.com>

RUN apk update && apk add gitolite openssh openssh-client
COPY run-gitolite.sh /usr/local/bin/run-gitolite.sh
RUN chmod 0555 /usr/local/bin/run-gitolite.sh

USER root
EXPOSE 22/tcp
VOLUME ["/import", "/secrets", "/var/lib/git"]

CMD ["/bin/sh", "/usr/local/bin/run-gitolite.sh"]
