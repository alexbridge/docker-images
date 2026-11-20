#!/usr/bin/env bash
# Copy one order with dependent rows remote -> local.
# Usage: ./single-order.sh <ORDER_ID>

set -euo pipefail
. "$(dirname "$0")/utils.sh"

ORDER_ID="${1:-}"
if [[ -z "$ORDER_ID" ]]; then
  read -rp "Order ID to copy: " ORDER_ID
fi
[[ -n "$ORDER_ID" ]] || { echo "Order ID is empty"; exit 1; }

CUSTOMER_ID=$(selectOne "SELECT customer_id FROM ORDERS WHERE id = '${ORDER_ID}'")
[[ -n "$CUSTOMER_ID" ]] || { echo "No ORDERS row for id: ${ORDER_ID}"; exit 1; }

cat <<INFO
Copy data:
  Order ID:    ${ORDER_ID}
  Customer ID: ${CUSTOMER_ID}
INFO

declare -A byOrder=(
  [ORDERS]=id
  [ORDER_ITEM]=order_id
  [PAYMENT]=order_id
  [SHIPMENT]=order_id
)

declare -A byCustomer=(
  [CUSTOMER]=id
  [CUSTOMER_ADDRESS]=customer_id
)

copyTablesByMap byOrder "$ORDER_ID"
copyTablesByMap byCustomer "$CUSTOMER_ID"
