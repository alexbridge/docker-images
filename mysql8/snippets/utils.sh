#!/usr/bin/env bash

if [[ ! -v __INCLUDE_UTILS__ ]]; then __INCLUDE_UTILS__=true

SNIPPETS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

DB_NAME="${DB_NAME:-MYSQL_8}"
REMOTE="${REMOTE_CNF:-$SNIPPETS_DIR/cnf/remote.cnf}"
LOCAL="${LOCAL_CNF:-$SNIPPETS_DIR/cnf/local.cnf}"

MYSQL_DUMP_FLAGS="--set-gtid-purged=OFF --skip-triggers --no-create-info --no-tablespaces --skip-extended-insert --complete-insert"

if [[ ! -f "$REMOTE" ]]; then
  echo "Missing $REMOTE (copy cnf/remote.cnf.example)" >&2
  exit 1
fi

function selectOne() {
  local query="${1}"
  local config_file="${2:-$REMOTE}"

  mysql --defaults-file="$config_file" -Nse "${query}" "$DB_NAME"
}

function copySingle() {
  local table="${1}"
  local field="${2}"
  local fieldVal="${3}"
  local config_file="${4:-$REMOTE}"

  echo "  ${table}.${field}=${fieldVal}"
  mysqldump --defaults-file="$config_file" $MYSQL_DUMP_FLAGS "$DB_NAME" \
    --where="${field}='${fieldVal}'" "${table}" \
    | mysql --defaults-file="$LOCAL" "$DB_NAME"
}

# $1 = name of assoc array TABLE -> key column, $2 = key value
function copyTablesByMap() {
  local -n tablesMap=$1
  local fieldVal=$2
  local config_file="${3:-$REMOTE}"

  for table in "${!tablesMap[@]}"; do
    copySingle "${table}" "${tablesMap[$table]}" "${fieldVal}" "$config_file"
  done
}

fi
