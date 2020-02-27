FROM alpine:3.11
LABEL maintainer Caoimhe Chaos <caoimhechaos@protonmail.com>

RUN apk --update add dumb-init openssh-server borgbackup shadow
RUN addgroup -g 1337 borg
RUN adduser -h /srv/backup -g 'Borg backup user' -G borg -u 1337 -D borg
RUN usermod -p '*' borg
COPY run-sshd.sh /usr/local/bin/run-sshd.sh

VOLUME ["/srv/backup", "/etc/ssh", "/ssh-keys"]
CMD ["/bin/sh", "-x", "/usr/local/bin/run-sshd.sh"]
