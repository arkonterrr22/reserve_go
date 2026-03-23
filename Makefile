include .env
export

export PROJECT_ROOT=${shell pwd}

env-up:
	@docker compose up -d database-service

env-down:
	@docker compose down database-service

env-cleanup:
	@docker compose down database-service && \
	sudo rm -rf out/pgdata && \
	echo "БД удалена"

migrate-create:
	@if [ -z "$(seq)" ]; then \
		echo "Укажите название миграции (seq)" \
		exit 1; \
	fi; \
	docker compose run --rm database-migration \
		create \
		-ext sql \
		-dir /migrations \
		-seq "$(seq)"

migrate-up:
	@make migrate-action action=up

migrate-down:
	@make migrate-action action=down

migrate-action:
	@if [ -z "$(action)" ]; then \
		echo "Укажите действие (action)" \
		exit 1; \
	fi; \
	docker compose run --rm database-migration \
		-path /migrations \
		- database postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@database-service:5432/${POSTGRES_DB}?sslmode=disable \
		"$(action)"