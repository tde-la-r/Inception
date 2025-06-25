all: up

up:
	@clear
	@docker compose -f srcs/docker-compose.yml up --build -d

down:
	@docker compose -f srcs/docker-compose.yml down

clean:
	@docker compose -f srcs/docker-compose.yml down -v
	@docker system prune -af
	@sudo rm -rf ~/data/mariadb/* ~/data/wordpress/*
	@echo "Volumes files removed."

re: clean all

.PHONY: up down clean re
