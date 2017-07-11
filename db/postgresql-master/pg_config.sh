#!/bin/sh
#
# Copyright (c) 2017, Caoimhe Chaos <caoimhechaos@protonmail.com>.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
# * Redistributions of source code must retain the above copyright notice,
#   this list of conditions and the following disclaimer.
#
# * Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the
#   documentation and/or other materials provided with the distribution.
#
# * Neither the name of Ancient Solutions nor the names of its
#   contributors may be used to endorse or promote products derived from
#   this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

set -x

POSTGRESQL_VERSION="9.6"

if [ ! -f "/var/lib/postgresql/${POSTGRESQL_VERSION}/main/PG_VERSION" ]
then
	/usr/bin/pg_createcluster "${POSTGRESQL_VERSION}" main
fi

# Set up configuration directory.
mkdir -p "/etc/postgresql/${POSTGRESQL_VERSION}/main"
chgrp -R postgres "/etc/postgresql/${POSTGRESQL_VERSION}/main"

# Make sure we start from a clean config state.
rm -f "/etc/postgresql/${POSTGRESQL_VERSION}/main/postgresql.conf"
touch "/etc/postgresql/${POSTGRESQL_VERSION}/main/postgresql.conf"

install -o postgres -g postgres -m 2775 -d "/var/run/postgresql/${POSTGRESQL_VERSION}-main.pg_stat_tmp"
rm -f "/var/lib/postgresql/${POSTGRESQL_VERSION}/main/postmaster.pid"

# Access
/usr/bin/pg_conftool -- set listen_addresses '*'
/usr/bin/pg_conftool -- set ssl on
/usr/bin/pg_conftool -- set ssl_prefer_server_ciphers on
/usr/bin/pg_conftool -- set ssl_ciphers 'ALL:!ADH:!LOW:!EXP:!MD5:@STRENGTH'
/usr/bin/pg_conftool -- set password_encryption on
/usr/bin/pg_conftool -- set db_user_namespace off

# Tuning paramaters
/usr/bin/pg_conftool -- set shared_buffers 480MB
/usr/bin/pg_conftool -- set temp_buffers 8MB
/usr/bin/pg_conftool -- set max_prepared_transactions 64
/usr/bin/pg_conftool -- set work_mem 10MB
/usr/bin/pg_conftool -- set maintenance_work_mem 120MB
/usr/bin/pg_conftool -- set max_stack_depth 2MB
/usr/bin/pg_conftool -- set dynamic_shared_memory_type posix
/usr/bin/pg_conftool -- set full_page_writes on
/usr/bin/pg_conftool -- set wal_buffers 4MB
/usr/bin/pg_conftool -- set wal_writer_delay 200ms

# Query tuning
/usr/bin/pg_conftool -- set enable_bitmapscan on
/usr/bin/pg_conftool -- set enable_hashagg on
/usr/bin/pg_conftool -- set enable_hashjoin on
/usr/bin/pg_conftool -- set enable_material on
/usr/bin/pg_conftool -- set enable_mergejoin on
/usr/bin/pg_conftool -- set enable_nestloop on
/usr/bin/pg_conftool -- set enable_seqscan on
/usr/bin/pg_conftool -- set enable_sort on
/usr/bin/pg_conftool -- set enable_tidscan on
/usr/bin/pg_conftool -- set default_statistics_target 10
/usr/bin/pg_conftool -- set constraint_exclusion off
/usr/bin/pg_conftool -- set cursor_tuple_fraction 0.1
/usr/bin/pg_conftool -- set from_collapse_limit 8
/usr/bin/pg_conftool -- set join_collapse_limit 8

/usr/bin/pg_conftool -- set geqo on
/usr/bin/pg_conftool -- set geqo_threshold 12
/usr/bin/pg_conftool -- set geqo_effort 5
/usr/bin/pg_conftool -- set geqo_pool_size 0
/usr/bin/pg_conftool -- set geqo_generations 0
/usr/bin/pg_conftool -- set geqo_selection_bias 2.0
/usr/bin/pg_conftool -- set geqo_seed 0.0

# Vacuuming
/usr/bin/pg_conftool -- set autovacuum on
/usr/bin/pg_conftool -- set track_activities on
/usr/bin/pg_conftool -- set track_counts on
/usr/bin/pg_conftool -- set track_io_timing on
/usr/bin/pg_conftool -- set track_functions none
/usr/bin/pg_conftool -- set track_activity_query_size 1024
/usr/bin/pg_conftool -- set log_autovacuum_min_duration 120000
/usr/bin/pg_conftool -- set autovacuum_max_workers 3
/usr/bin/pg_conftool -- set autovacuum_naptime 1min
/usr/bin/pg_conftool -- set autovacuum_vacuum_threshold 50
/usr/bin/pg_conftool -- set autovacuum_analyze_threshold 50
/usr/bin/pg_conftool -- set autovacuum_vacuum_scale_factor 0.2
/usr/bin/pg_conftool -- set autovacuum_analyze_scale_factor 0.1
/usr/bin/pg_conftool -- set autovacuum_freeze_max_age 200000000
/usr/bin/pg_conftool -- set autovacuum_multixact_freeze_max_age 400000000
/usr/bin/pg_conftool -- set autovacuum_vacuum_cost_delay 20ms
/usr/bin/pg_conftool -- set autovacuum_vacuum_cost_limit -1

# Replication
/usr/bin/pg_conftool -- set hot_standby on
/usr/bin/pg_conftool -- set hot_standby_feedback on
/usr/bin/pg_conftool -- set wal_level hot_standby
/usr/bin/pg_conftool -- set max_wal_senders 5
/usr/bin/pg_conftool -- set wal_keep_segments 8
/usr/bin/pg_conftool -- set min_wal_size 64MB
/usr/bin/pg_conftool -- set max_wal_size 2048MB
/usr/bin/pg_conftool -- set checkpoint_completion_target 0.7

# Logging
/usr/bin/pg_conftool -- set log_destination stderr
/usr/bin/pg_conftool -- set log_parser_stats off
/usr/bin/pg_conftool -- set log_planner_stats off
/usr/bin/pg_conftool -- set log_executor_stats off
/usr/bin/pg_conftool -- set log_statement_stats off
/usr/bin/pg_conftool -- set update_process_title on

# Locale
/usr/bin/pg_conftool -- set lc_messages en_US.UTF-8
/usr/bin/pg_conftool -- set lc_monetary en_US.UTF-8
/usr/bin/pg_conftool -- set lc_numeric en_US.UTF-8
/usr/bin/pg_conftool -- set lc_time en_US.UTF-8

# Secret configuration
/usr/bin/pg_conftool -- set ssl_cert_file /tls/tls.crt
/usr/bin/pg_conftool -- set ssl_key_file /tls/tls.key

# Authentication related configuration.
# TODO(caoimhe): generate hba config from etcd on demand.
/usr/bin/pg_conftool -- set hba_file /config/postgresql.hba.conf
/usr/bin/pg_conftool -- set ident_file /config/postgresql.ident.conf

exec "/usr/lib/postgresql/${POSTGRESQL_VERSION}/bin/postmaster" "-D" "/var/lib/postgresql/${POSTGRESQL_VERSION}/main" "-c" "config_file=/etc/postgresql/${POSTGRESQL_VERSION}/main/postgresql.conf"
