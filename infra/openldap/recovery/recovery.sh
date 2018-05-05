#!/bin/sh
#
# Run LDAP recovery on default OpenLDAP data directory.
#

set -e

cd /var/lib/openldap/openldap-data
exec /usr/bin/db_recover
