SHELL := /bin/bash

generate-users:
	@read -p "Username (default: admin)  ?: " DOZZLE_USER; \
	read -p "Password (default: admin)  ?: " DOZZLE_PASS; \
	docker run amir20/dozzle generate "$${DOZZLE_USER:-admin}" --password "$${DOZZLE_USER:-admin}" > users.yml

start:
	docker compose up -d