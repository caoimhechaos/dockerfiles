FROM debian:testing
LABEL maintainer="Caoimhe Chaos <caoimhechaos@protonmail.com>"

RUN ["/usr/bin/apt-get", "-q", "-y", "-o", "Dpkg::Options::=--force-confdef", "-o", "Dpkg::Options::=--force-confold", "update"]
RUN ["/usr/bin/apt-get", "-q", "-y", "-o", "Dpkg::Options::=--force-confdef", "-o", "Dpkg::Options::=--force-confold", "--purge", "install", "build-essential", "pbuilder", "devscripts", "packaging-dev", "dose-buildcheckdeb"]
COPY pbuilderrc /etc/pbuilderrc
RUN ["/usr/sbin/pbuilder", "create"]
RUN ["/bin/mkdir", "-p", "/build"]
WORKDIR /build

VOLUME ["/build"]
ENTRYPOINT ["/usr/bin/pdebuild"]
