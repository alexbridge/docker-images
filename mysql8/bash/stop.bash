#!/usr/bin/env bash

set -e
cd "$(dirname "$0")" > /dev/null || exit 1

source ../../bash/helpers/Color.sh
source ../../bash/helpers/Echo.sh
source ../../bash/helpers/Utils.sh

trap 'Utils::trap' ERR

Echo::info "Shutting down apps"

docker compose --env-file ../.env --file ../docker-compose.yml down -v > /dev/null || true

Echo::success "Done"
