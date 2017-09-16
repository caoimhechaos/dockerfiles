OpenLDAP master/slave container
===============================

This container provides the necessary functionality to run as an OpenLDAP master
or slave.

Environment
-----------

The following environment variables are expected to be set:
 * *LDAP_DNS_DOMAINNAME* is the name of the DNS domain most commonly associated
   with the DNS server. This is mostly used in Kerberos setups.
 * *LDAP_BASE_DN* is the base DN container all data will be held inside of.
   Usually, this will be either dc=yourdomain,dc=com or something like
   O=something.
 * *LDAP_SASL_HOST* is the name this host will be externally referenced as.

The following environment variables are optional:

 * *LDAP_MASTER* can be set to the host name of an LDAP master. If this variable
   is set, the server will be configured as an LDAP slave replica; if not, it
   will be configured as a master.

Volumes
-------

The following volumes are expected to be mounted:

 * */secret/ldap_root_pw* is expected to contain a file named *manager* which
   can contain a hash of the LDAP manager password.
 * */secret/ldap_syncrepl_pw* is expected to contain a file named *syncrepl*
   with the password (no hash) of the syncrepl user, if a master is specified
   in the environment.
 * */ssl* is expected to contain files named *tls.crt* and *tls.key* holding the
   TLS certificate and key of the LDAP server.
 * */sslca* is expected to contain a file named *ca.crt* containing the CA
   certificate for identifying and authenticating peers and clients.
 * */var/lib/openldap/openldap-data* is expected to be a permanent storage
   volume. The LDAP database will be stored in this directory.
