include .env
export
USER := root

up:
	@docker compose up -d database
	@timeout 15 bash -c 'echo $(MYSQL_ROOT_PASSWORD); until docker compose exec database mysql -u root -proot dcr_db -e "SELECT 1"; do echo hoge; sleep 1; done' || (echo "Failed to connect to MySQL within 15 seconds" && exit 1)
	@FLYWAY_COMMAND=migrate docker compose run --rm flyway

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
