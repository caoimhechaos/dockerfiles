FROM debian:testing
MAINTAINER Caoimhe Chaos <caoimhechaos@protonmail.com>

# Build the sources.list file.
RUN echo "deb http://debian.l.internetputzen.com/debian/ testing main contrib non-free" > /etc/apt/sources.list
RUN echo "deb http://debian.l.internetputzen.com/security/ testing/updates main contrib non-free" >> /etc/apt/sources.list

# Apply changes so we can install curl.
RUN apt-get update
RUN apt-get -q -y -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold --purge install curl gnupg2

# Now add the ancient solutions apt source.
RUN echo "deb http://debian.l.internetputzen.com/ancientsolutions/ testing main third-party" > /etc/apt/sources.list.d/ancientsolutions.list

# Install the ancient solutions debian key.
RUN curl -k -m 30 https://caoimhe.io/caoimhe.asc | apt-key add -

# Apply apt changes.
ONBUILD RUN apt-get -q -y update

# Install the CA.
ONBUILD RUN apt-get -q -y -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold --purge install ancient-ca
