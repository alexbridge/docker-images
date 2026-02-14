IMAGES_DIR := archive

.PHONY: docker-commit

docker-start-stored:
	docker load -i $(IMAGES_DIR)/mysql.tar
	docker load -i $(IMAGES_DIR)/opencart.tar
	docker compose up -d
docker-stop-stored:
	docker compose down

docker-start-initial:
	docker compose -f docker-compose-initial.yml up -d
docker-stop-initial:
	docker compose -f docker-compose-initial.yml down

docker-commit-initial:
	@mkdir -p $(IMAGES_DIR)
	@docker compose -f docker-compose-initial.yml ps --services | while read service; do \
		echo "Checking service: $$service"; \
		container_id=$$(docker compose ps -q $$service); \
		if [ -n "$$container_id" ]; then \
			image_tag="docker-images/opencart-$$service:latest"; \
			echo "Committing $$container_id to $$image_tag..."; \
			docker commit $$container_id $$image_tag; \
			filename="$(IMAGES_DIR)/$$service.tar"; \
			echo "Saving $$image_tag to $$filename..."; \
			docker save -o $$filename $$image_tag; \
			echo "Successfully saved $$service."; \
		else \
			echo "No running container found for service: $$service"; \
		fi; \
	done
	@echo "All running containers committed and saved to $(IMAGES_DIR)/"
