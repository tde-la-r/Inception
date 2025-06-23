all: up

up:
	@clear
	@docker compose up --build -d

down:
	@docker compose down

clean:
	@docker compose down -v
	@docker system prune -af
	@sudo rm -rf ~/data/mariadb/* ~/data/wordpress/*
	@echo "Volumes files removed."

re: clean all

.PHONY: up down clean re
