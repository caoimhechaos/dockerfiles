FROM caoimhechaos/ancientsolutions-base:testing
MAINTAINER Caoimhe Chaos <caoimhechaos@protonmail.com>

RUN curl -k -m 30 https://download.owncloud.org/download/repositories/9.0/Debian_8.0/Release.key | apt-key add -

COPY sources.list /etc/apt/sources.list.d/owncloud.list

RUN apt-get update
RUN apt-get -q -y -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold --purge install owncloud owncloud-files owncloud-client-cmd php7.0-pgsql php7.0-sqlite php7.0-cli php7.0-common php7.0-curl php7.0-gd php7.0-imap php7.0-intl php7.0-json php7.0-ldap php7.0-mbstring php7.0-mcrypt php7.0-mysql php7.0-opcache php7.0-pgsql php7.0-readline php7.0-sqlite3 php7.0-xml php7.0-zip apache2 apache2-bin apache2-data apache2-utils cron ssmtp file clamav-unofficial-sigs ssl-cert libreoffice kviator

COPY apache-owncloud.conf /etc/apache2/sites-available/owncloud.conf

RUN /usr/sbin/a2enmod ssl
RUN /usr/sbin/a2enmod headers
RUN /usr/sbin/a2dissite 000-default.conf
RUN /usr/sbin/a2ensite owncloud.conf

# Improve SSL configuration.
RUN /bin/sed -i -e 's/^[#\t ]*SSLCipherSuite.*$/SSLCipherSuite EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH/g' /etc/apache2/mods-available/ssl.conf
RUN /bin/sed -i -e 's/^[#\t ]*SSLProtocol.*$/SSLProtocol All -SSLv2 -SSLv3/g' /etc/apache2/mods-available/ssl.conf
RUN /bin/sed -i -e 's/^[#\t ]*SSLHonorCipherOrder.*$/SSLHonorCipherOrder On/g' /etc/apache2/mods-available/ssl.conf
RUN /bin/sed -i -e 's@^[#\t ]*SSLCertificateFile.*$@SSLCertificateFile /secret/owncloud-cert/fullchain.pem@g' /etc/apache2/mods-available/ssl.conf
RUN /bin/sed -i -e 's@^[#\t ]*SSLCertificateKeyFile.*$@SSLCertificateKeyFile /secret/owncloud-cert/privkey.pem@g' /etc/apache2/mods-available/ssl.conf
RUN /bin/sed -i -e '/IfModule\>/i Header always set Strict-Transport-Security "max-age=63072000; preload"' /etc/apache2/mods-available/ssl.conf
RUN /bin/sed -i -e '/IfModule\>/i Header always set X-Frame-Options SAMEORIGIN' /etc/apache2/mods-available/ssl.conf
RUN /bin/sed -i -e '/IfModule\>/i Header always set X-Content-Type-Options nosniff' /etc/apache2/mods-available/ssl.conf
RUN /bin/sed -i -e '/IfModule\>/i Header always set X-XSS-Protection "1; mode=block"' /etc/apache2/mods-available/ssl.conf
RUN /bin/sed -i -e '/IfModule\>/i SSLCompression off' /etc/apache2/mods-available/ssl.conf
RUN /bin/sed -i -e '/IfModule\>/i SSLSessionTickets Off' /etc/apache2/mods-available/ssl.conf
RUN /bin/sed -i -e '/IfModule\>/i SSLUseStapling on' /etc/apache2/mods-available/ssl.conf
RUN /bin/sed -i -e '/IfModule\>/i SSLStaplingCache "shmcb:logs/stapling-cache(150000)"' /etc/apache2/mods-available/ssl.conf
RUN mkdir -p /secret/owncloud-cert

EXPOSE 80/tcp 443/tcp
VOLUME ["/var/www/owncloud/apps", "/var/www/owncloud/config", "/var/www/owncloud/data", "/secret/owncloud-cert"]

ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_RUN_GROUP www-data
ENV APACHE_RUN_USER www-data

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
