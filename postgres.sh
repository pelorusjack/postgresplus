#!/bin/sh
set -e

cat <<-EOF >> $PGDATA/postgresql.conf
max_replication_slots = 10
max_wal_senders = 10
wal_level = logical


shared_preload_libraries = 'jsoncdc'
EOF

cat <<-EOF >> $PGDATA/pg_hba.conf
host replication replication 0.0.0.0/0 md5
local replication all trust
EOF

sed -i -e"s/^#log_connections = off.*$/log_connections = on/" /var/lib/postgresql/data/postgresql.conf
sed -i -e"s/^#log_min_messages = warning.*$/log_min_messages = info/" /var/lib/postgresql/data/postgresql.conf
sed -i -e"s/^log_line_prefix = '\%t \[\%p-\%l\] \%q\%u@\%d '.*$/log_line_prefix = '\%t \[\%p\]: \[\%l-1\] user=\%u,db=\%d'/" /var/lib/postgresql/data/postgresql.conf
sed -i -e"s/^#log_lock_waits = off.*$/log_lock_waits = on/" /var/lib/postgresql/data/postgresql.conf
sed -i -e"s/^#log_temp_files = -1.*$/log_temp_files = 0/" /var/lib/postgresql/data/postgresql.conf
sed -i -e"s/^#statement_timeout = 0.*$/statement_timeout = 1800000        # in milliseconds, 0 is disabled (current 30min)/" /var/lib/postgresql/data/postgresql.conf
sed -i -e"s/^lc_messages = 'en_US.UTF-8'.*$/lc_messages = 'C'/" /var/lib/postgresql/data/postgresql.conf
sed -ri "s/#log_statement = 'none'/log_statement = 'all'/g" /var/lib/postgresql/data/postgresql.conf
