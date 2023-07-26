SHELL := /bin/bash

.DEFAULT:
_recipe-list:
	@recipe=$$(grep -oE '^[a-z][a-zA-Z0-9-]+:' Makefile | tr -d ':' | \
	fzf --preview 'make --silent -n {} | head -n 5' --preview-window=50%:down); \
	[[ -n "$$recipe" ]] && make --silent $$recipe

tag-image:
	docker build . -t fusionauth/fusionauth-mysql:latest	

start:
	# Start app container with .env params
	./bash/start.bash

stop: 
	# Stop app
	./bash/stop.bash