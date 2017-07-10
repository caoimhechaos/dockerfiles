PostgreSQL Simple Master
========================

docker.io/caoimhechaos/postgresql-simple-master provides a simple PostgreSQL container which does not include replication or master election. It is a single PostgreSQL server. The container is designed to be run on a distributed scheduling system (such as [Kubernetes](https://kubernetes.io/)).

Mount points
------------

 * /var/lib/postgresql: permanent storage for the contents of the PostgreSQL database. Example: ceph rdb.
 * /tls: certificate and private key storage (ideally tmpfs).
 * /config: subdirectory for specific configuration files (see below). Not necessarily secret, so this can be a simple configmap and doesn’t need to be tempts.

Certificate mount point
-----------------------

Certificates must be provided as base64 PEM encoded X.509 certificate and key files. The following files are expected to be present:

 * /tls/tls.crt: X.509 certificate.
 * /tls/tls.key: Private key belonging to the above certificate.

If you want to create a test certificate and key, you can do so by invoking the following command:

> % openssl req -new -newkey rsa:4096 -keyout tls.key -out tls.crt -x509 -subj /CN=yourhostname
> % kubectl create secret tls postgresql-test-cert --cert=tls.crt --key=tls.key

Configuration files
-------------------

Much of the general PostgreSQL configuration is provided automatically. The following files are expected to be mounted to /config:

 * /config/postgresql.hba.conf: host-based access control file.
 * /config/postgresql.ident.conf: ident-based configuration. You probably want this to be empty.

Caveats
-------

Since by definition postgresql-simple-master is single-homed, this container is only useful for setups where outages of 20 minutes or more (rescheduling and startup interval) can be tolerated. An example would be a system where the PostgreSQL database is only used to synchronise data into an in-memory cache.
