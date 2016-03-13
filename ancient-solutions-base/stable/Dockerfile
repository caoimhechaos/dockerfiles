FROM debian:stable
MAINTAINER Caoimhe Chaos <caoimhechaos@protonmail.com>

# Build the sources.list file.
RUN echo "deb http://debian.l.internetputzen.com/debian/ stable main contrib non-free" > /etc/apt/sources.list
RUN echo "deb http://debian.l.internetputzen.com/security/ stable/updates main contrib non-free" >> /etc/apt/sources.list

# Apply changes so we can install curl.
RUN apt-get update
RUN apt-get -q -y -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold --purge install curl

# Now add the ancient solutions apt source.
RUN echo "deb http://debian.l.internetputzen.com/ancientsolutions/ stable main third-party" > /etc/apt/sources.list.d/ancientsolutions.list

# Install the ancient solutions debian key.
RUN apt-key adv --keyserver wwwkeys.uk.pgp.net --recv-key C74A8F85

# Apply apt changes.
ONBUILD RUN apt-get -q -y update

# Install the CA.
ONBUILD RUN apt-get -q -y -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold --purge install ancient-ca
