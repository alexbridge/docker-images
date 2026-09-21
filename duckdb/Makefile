SHELL := /bin/bash

COMPOSE := docker compose --env-file .env --file docker-compose.yml

.DEFAULT:
_recipe-list:
	@recipe=$$(grep -oE '^[a-z][a-zA-Z0-9-]+:' Makefile | tr -d ':' | \
	fzf --preview 'make --silent -n {} | head -n 5' --preview-window=50%:down); \
	[[ -n "$$recipe" ]] && make --silent $$recipe

start: stop
	# Build the image, seed the database on first run and serve the DuckDB Web UI
	$(COMPOSE) build duckdb
	$(COMPOSE) up -d --force-recreate duckdb

stop:
	# Stop duckdb and drop its data volume
	$(COMPOSE) down -v || true

shell:
	# DuckDB REPL. One process may hold the database file, so the UI yields it and
	# is restarted on exit
	$(COMPOSE) stop duckdb
	-$(COMPOSE) run --rm --no-deps --entrypoint duckdb duckdb /data/playground.duckdb
	$(COMPOSE) start duckdb

logs:
	$(COMPOSE) logs -f duckdb
