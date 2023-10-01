SHELL := /bin/bash

COMPOSE_FILE := -f ./docker-compose.yml

start: stop
	docker compose $(COMPOSE_FILE) up --build --detach
stop:
	docker compose $(COMPOSE_FILE) down