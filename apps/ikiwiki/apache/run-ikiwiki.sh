#!/bin/bash
set -x

# Create directories for all ikiwiki configurations.
grep -v '^#' /etc/ikiwiki/wikilist | awk '{ print $2 }' | while read filename
do
    host="$(egrep '^[[:space:]]*url => ' $filename | awk -F\' '{ print $2 }' | awk -F/ '{ print $3 }')"
    srcdir="$(egrep '^[[:space:]]*srcdir => ' $filename | awk -F\' '{ print $2 }')"
    destdir="$(egrep '^[[:space:]]*destdir => ' $filename | awk -F\' '{ print $2 }')"
    libdir="$(egrep '^[[:space:]]*libdir => ' $filename | awk -F\' '{ print $2 }')"
    git_wrapper="$(egrep '^[[:space:]]*git_wrapper => ' $filename | awk -F\' '{ print $2 }')"
    wikiname="$(egrep '^[[:space:]]*wikiname => ' $filename | awk -F\' '{ print $2 }')"
    git_dir="$(dirname "$(dirname "$git_wrapper")")"

    /usr/bin/install -o www-data -g git -m 0750 -d "$destdir" "$libdir"

    (cd "$(dirname "$srcdir")" && \
        git clone "$git_dir" "$(basename "$srcdir")" && \
        /usr/bin/ikiwiki --setup "$filename")

    output="$(mktemp -t apache-config-snippet.XXXXXX)"
    echo "Writing temporary configuration to $output"
    cat << EOT > $output
    ServerName $host
    DocumentRoot $destdir

    <Directory "$destdir">
        Options ExecCGI FollowSymLinks
        AddHandler cgi-script .cgi
        AllowOverride AuthConfig Limit
        Require all granted
    </Directory>
EOT

    if [ -n "$LDAP_HOST" ] && [ -n "$LDAP_SUFFIX" ]
    then
        cat << EOT >> $output

    <Location /ikiwiki.cgi>
        AuthType basic
        AuthName "$wikiname Login"
        AuthBasicProvider ldap
        AuthLDAPUrl "ldaps://$LDAP_HOST/ou=People,$LDAP_SUFFIX?uid"
        AuthLDAPGroupAttribute memberUid
        AuthLDAPGroupAttributeIsDN off
        Require valid-user

        LDAPTrustedClientCert CERT_BASE64 /secret/tls.crt
        LDAPTrustedClientCert KEY_BASE64 /secret/tls.key
    </Location>
EOT
    fi

    echo "<VirtualHost _default_:8080>" > /etc/apache2/sites-available/$host.conf
    cat $output >> /etc/apache2/sites-available/$host.conf
    echo "</VirtualHost>" >> /etc/apache2/sites-available/$host.conf
    echo "<IfModule ssl_module>" >> /etc/apache2/sites-available/$host.conf
    echo "<VirtualHost _default_:8443>" >> /etc/apache2/sites-available/$host.conf
    cat $output >> /etc/apache2/sites-available/$host.conf
    echo >> /etc/apache2/sites-available/$host.conf
    echo "    SSLEngine on" >> /etc/apache2/sites-available/$host.conf
    echo "    SSLCertificateFile \"/secret/tls.crt\"" >> /etc/apache2/sites-available/$host.conf
    echo "    SSLCertificateKeyFile \"/secret/tls.key\"" >> /etc/apache2/sites-available/$host.conf
    echo "</VirtualHost>" >> /etc/apache2/sites-available/$host.conf
    echo "</IfModule>" >> /etc/apache2/sites-available/$host.conf
    echo "<IfModule mod_gnutls.c>" >> /etc/apache2/sites-available/$host.conf
    echo "<VirtualHost _default_:8443>" >> /etc/apache2/sites-available/$host.conf
    cat $output >> /etc/apache2/sites-available/$host.conf
    echo >> /etc/apache2/sites-available/$host.conf
    echo "    SSLEngine on" >> /etc/apache2/sites-available/$host.conf
    echo "    SSLCertificateFile \"/secret/tls.crt\"" >> /etc/apache2/sites-available/$host.conf
    echo "    SSLCertificateKeyFile \"/secret/tls.key\"" >> /etc/apache2/sites-available/$host.conf
    echo "</VirtualHost>" >> /etc/apache2/sites-available/$host.conf
    echo "</IfModule>" >> /etc/apache2/sites-available/$host.conf

    /usr/sbin/a2ensite "$host"
done

/usr/sbin/ikiwiki-mass-rebuild || exit 1

/usr/sbin/apache2 -k start -DFOREGROUND
/bin/cat /var/log/apache2/error.log
