#!/usr/bin/env bash
# Truncate all local tables. Local only, never remote.

set -euo pipefail
. "$(dirname "$0")/utils.sh"

mysql --defaults-file="$LOCAL" -Nse 'SHOW TABLES' "$DB_NAME" | while read -r table; do
  mysql --defaults-file="$LOCAL" -e "SET foreign_key_checks = 0; TRUNCATE TABLE \`${table}\`" "$DB_NAME"
  echo -n '.'
done
echo ' done'
