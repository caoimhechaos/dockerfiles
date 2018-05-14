FROM debian:stable
MAINTAINER Caoimhe Chaos <caoimhechaos@protonmail.com>

# Apply changes so we can install apt-transport-https.
RUN apt-get -q -y update
RUN apt-get -q -y -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold --purge install apt-transport-https


# Build the sources.list file.
RUN echo "deb http://debian.l.internetputzen.com/debian/ stable main contrib non-free" > /etc/apt/sources.list
RUN echo "deb http://debian.l.internetputzen.com/security/ stable/updates main contrib non-free" >> /etc/apt/sources.list

# Apply changes so we can install curl.
RUN apt-get -q -y update
RUN apt-get -q -y -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold --purge install curl

# Now add the ancient solutions apt source.
RUN echo "deb http://debian.l.internetputzen.com/ancientsolutions/ stable main third-party" > /etc/apt/sources.list.d/ancientsolutions.list

# Install the ancient solutions debian key.
RUN curl -k -m 30 https://caoimhe.io/caoimhe.asc | apt-key add -

# Apply apt changes.
ONBUILD RUN apt-get -q -y update

# Install the CA.
ONBUILD RUN apt-get -q -y -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold --purge install ancient-ca
