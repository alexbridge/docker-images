#!/usr/bin/env bash

set -e
cd "$(dirname "$0")" > /dev/null || exit 1

source ../../bash/helpers/Color.sh
source ../../bash/helpers/Echo.sh
source ../../bash/helpers/Docker.sh
source ../../bash/helpers/Utils.sh

trap 'Utils::trap' ERR

echo "$(pwd)"

./stop.bash

Echo::info "Starting APPs ... "

docker compose --env-file ../.env --file ../docker-compose.yml up -d --force-recreate mysql fusionauth

Echo::success "Done"
