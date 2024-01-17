include .env
export
USER := root

up:
	@docker compose up -d database

down:
	@docker compose down database

connect:
	@docker compose exec database mysql -u $(USER) -p

flyway-migrate:
	@FLYWAY_COMMAND=migrate docker compose run --rm flyway

flyway-validate:
	@FLYWAY_COMMAND=validate docker compose run --rm flyway

flyway-clean:
	@FLYWAY_COMMAND=clean docker compose run --rm flyway

flyway-repair:
	@FLYWAY_COMMAND=repair docker compose run --rm flyway

flyway-info:
	@FLYWAY_COMMAND=info docker compose run --rm flyway
