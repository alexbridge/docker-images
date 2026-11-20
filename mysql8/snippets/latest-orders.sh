#!/usr/bin/env bash
# Copy latest N orders remote -> local.
# Usage: LIMIT=20 ./latest-orders.sh

set -euo pipefail
cd "$(dirname "$0")"
. ./utils.sh

LIMIT="${LIMIT:-10}"
echo "Copying latest ${LIMIT} orders"

mysql --defaults-file="$REMOTE" -Nse "SELECT id FROM ORDERS ORDER BY id DESC LIMIT ${LIMIT}" "$DB_NAME" \
  | while read -r orderId; do ./single-order.sh "$orderId" || true; done
