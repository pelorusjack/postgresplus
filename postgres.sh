#!/bin/sh
set -e

cat <<-EOF >> $PGDATA/postgresql.conf
max_replication_slots = 1
max_wal_senders = 1
wal_level = logical
EOF

cat <<-EOF >> $PGDATA/pg_hba.conf
host replication replication 0.0.0.0/0 md5
local replication all trust
EOF
