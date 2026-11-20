#!/usr/bin/env bash
# Copy full dictionary/config tables remote -> local.

set -euo pipefail
. "$(dirname "$0")/utils.sh"

TABLES=(
  "CONFIG"
  "FEATURE_FLAG"
  "DICT_COUNTRY"
  "DICT_CURRENCY"
)

for table in "${TABLES[@]}"; do
  echo "Copying table: ${table}"
  mysqldump --defaults-file="$REMOTE" $MYSQL_DUMP_FLAGS "$DB_NAME" "$table" \
    | mysql --defaults-file="$LOCAL" "$DB_NAME"
done
