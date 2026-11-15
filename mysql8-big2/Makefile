SHELL := /bin/bash

.DEFAULT:
_recipe-list:
	@recipe=$$(grep -oE '^[a-z][a-zA-Z0-9-]+:' Makefile | tr -d ':' | \
	fzf --preview 'make --silent -n {} | head -n 5' --preview-window=50%:down); \
	[[ -n "$$recipe" ]] && make --silent $$recipe

start: stop
	# Start mysql container with .env params
	docker compose --env-file .env --file docker-compose.yml up -d --force-recreate mysql
	docker logs -f mysql8-big2-mysql

stop:
	# Stop mysql
	docker compose --env-file .env --file docker-compose.yml down -v || true
