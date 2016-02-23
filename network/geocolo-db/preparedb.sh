#!/bin/sh
set -e
su postgres -c "nohup /usr/lib/postgresql/9.5/bin/postmaster -D /var/lib/postgresql/9.5/main      -c config_file=/etc/postgresql/9.5/main/postgresql.conf > /tmp/gen-postgresql.log 2>&1 < /dev/null &"
attempts=60

# Wait for PostgreSQL to come up.
while ! test -e /var/run/postgresql/.s.PGSQL.5432
do
	sleep 1
	attempts="$(expr "$attempts" - 1)"
	if test "$attempts" = 0
	then
		cat /tmp/gen-postgresql.log
		rm -f /tmp/gen-postgresql.log
		exit 10
	fi
done

ls -l /usr/share/postgresql/9.5/contrib/
su postgres -c "createdb gis"
su postgres -c "psql -f /usr/share/postgresql/9.5/contrib/postgis-2.2/postgis.sql gis"
su postgres -c "psql -f /usr/share/postgresql/9.5/contrib/postgis-2.2/legacy.sql gis"
su postgres -c "psql -f geoborders.sql gis"
su postgres -c "psql -c \"CREATE ROLE georeader WITH NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN ENCRYPTED PASSWORD 'blahblahblubberblubber';\" postgres"
su postgres -c "psql -c \"REVOKE CREATE ON SCHEMA public FROM georeader;\" gis"
su postgres -c "psql -c \"GRANT SELECT ON TABLE geoborders, spatial_ref_sys TO georeader;\" gis"

pkill postmaster

# Wait for postmaster to shut down properly.
attempts=96
while pgrep postmaster
do
	sleep 1
	attempts="$(expr "$attempts" - 1)"
	if test "$attempts" = 0
	then
		cat /tmp/gen-postgresql.log
		rm -f /tmp/gen-postgresql.log
		exit 10
	fi
done

rm -f /tmp/gen-postgresql.log
