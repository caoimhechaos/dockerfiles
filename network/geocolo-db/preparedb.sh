#!/bin/sh
set -e
su postgres -c "nohup /usr/lib/postgresql/9.4/bin/postmaster -D /var/lib/postgresql/9.4/main      -c config_file=/etc/postgresql/9.4/main/postgresql.conf > /dev/null 2>&1 < /dev/null &"
attempts=60

# Wait for PostgreSQL to come up.
while ! test -e /var/run/postgresql/.s.PGSQL.5432
do
	sleep 1
	attempts="$(expr "$attempts" - 1)"
	if test "$attempts" = 0
	then
		exit 10
	fi
done

su postgres -c "createdb gis"
su postgres -c "psql -f /usr/share/postgresql/9.4/contrib/postgis-2.1/postgis.sql gis"
su postgres -c "psql -f /usr/share/postgresql/9.4/contrib/postgis-2.1/legacy.sql gis"
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
		exit 10
	fi
done
