FROM debian:bookworm-slim

ARG DUCKDB_VERSION=1.4.1

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl unzip \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL -o /tmp/duckdb.zip \
      "https://github.com/duckdb/duckdb/releases/download/v${DUCKDB_VERSION}/duckdb_cli-linux-amd64.zip" \
    && unzip -q /tmp/duckdb.zip -d /usr/local/bin \
    && rm /tmp/duckdb.zip \
    && chmod +x /usr/local/bin/duckdb

ENV HOME=/root
# bake the extensions into the image so container start needs no network
RUN duckdb -c "INSTALL ui; INSTALL httpfs; INSTALL json;"

RUN cat > /usr/local/bin/entrypoint.bash <<'EOF' && chmod +x /usr/local/bin/entrypoint.bash
#!/usr/bin/env bash

set -euo pipefail

DB="${DUCKDB_DATABASE:-/data/playground.duckdb}"
INIT_DIR=/docker-entrypoint-initdb.d
SEED_MARKER=/data/.seeded
UI_PORT="${DUCKDB_UI_PORT:-4213}"

if [[ ! -f "$SEED_MARKER" ]]; then
    echo "==> seeding $DB (DUCKDB_SEED_ROWS=${DUCKDB_SEED_ROWS:-10000000})"
    for sql in "$INIT_DIR"/*.sql; do
        [[ -e "$sql" ]] || continue
        echo "--> $(basename "$sql")"
        # seed row count is injected as a DuckDB variable the scripts read back
        duckdb "$DB" \
            -c "SET VARIABLE seed_rows = ${DUCKDB_SEED_ROWS:-10000000};" \
            -c ".read $sql"
    done
    touch "$SEED_MARKER"
    echo "==> seeding done"
else
    echo "==> $DB already seeded, skipping init scripts"
fi

echo "==> DuckDB UI on http://localhost:${UI_PORT}"

# the UI server stops when its CLI session ends, so hold the session open on stdin
{ echo "SET GLOBAL ui_local_port = ${UI_PORT}; CALL start_ui_server();"; tail -f /dev/null; } \
    | duckdb "$DB"
EOF

WORKDIR /data
ENTRYPOINT ["/usr/local/bin/entrypoint.bash"]
