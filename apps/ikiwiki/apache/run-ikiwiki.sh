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
    git_dir="$(dirname "$(dirname "$git_wrapper")")"

    /usr/bin/install -o www-data -g git -m 0750 -d "$destdir" "$libdir"

    (cd "$(dirname "$srcdir")" && \
        git clone "$git_dir" "$(basename "$srcdir")" && \
        /usr/bin/ikiwiki --setup "$filename")

    cat << EOT > /etc/apache2/sites-available/$host.conf
<VirtualHost _default_:8080>
    ServerName $host
    DocumentRoot $destdir

    <Directory "$destdir">
        Options ExecCGI FollowSymLinks
        AddHandler cgi-script .cgi
        AllowOverride AuthConfig Limit
        Require all granted
    </Directory>
</VirtualHost>
<IfModule ssl_module>
<VirtualHost _default_:8443>
    ServerName $host
    DocumentRoot $destdir

    <Directory "$destdir">
        Options ExecCGI FollowSymLinks
        AddHandler cgi-script .cgi
        AllowOverride AuthConfig Limit
        Require all granted
    </Directory>

    SSLEngine on
    SSLCertificateFile "/secret/tls.crt"
    SSLCertificateKeyFile "/secret/tls.key"
</VirtualHost>
</IfModule>
<IfModule mod_gnutls.c>
<VirtualHost _default_:8443>
    ServerName $host
    DocumentRoot $destdir

    <Directory "$destdir">
        Options ExecCGI FollowSymLinks
        AddHandler cgi-script .cgi
        AllowOverride AuthConfig Limit
        Require all granted
    </Directory>

    SSLEngine on
    SSLCertificateFile "/secret/tls.crt"
    SSLCertificateKeyFile "/secret/tls.key"
</VirtualHost>
</IfModule>
EOT
    /usr/sbin/a2ensite "$host"
done

/usr/sbin/ikiwiki-mass-rebuild || exit 1

/usr/sbin/apache2 -k start -DFOREGROUND
/bin/cat /var/log/apache2/error.log
