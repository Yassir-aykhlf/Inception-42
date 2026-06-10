LOGIN		:= yaykhlf
DATA_DIR	:= /home/$(LOGIN)/data
COMPOSE_FILE	:= srcs/docker-compose.yml
COMPOSE		:= docker compose -f $(COMPOSE_FILE)

all:		setup build up

setup:
	@echo "Creating data directories..."
	@sudo mkdir -p $(DATA_DIR)/wordpress
	@sudo mkdir -p $(DATA_DIR)/mariadb
	@sudo chown -R $(USER):$(USER) $(DATA_DIR)

build:
	@echo "Building Docker images..."
	@$(COMPOSE) build

up:
	@echo "Starting services..."
	@$(COMPOSE) up -d

down:
	@echo "Stopping services..."
	@$(COMPOSE) down

stop:
	@echo "Stopping containers..."
	@$(COMPOSE) stop

start:
	@echo "Starting containers..."
	@$(COMPOSE) start

logs:
	@$(COMPOSE) logs -f

status:
	@$(COMPOSE) ps

clean: down
	@echo "Removing volumes..."
	@$(COMPOSE) down -v
	@sudo rm -fr $(DATA_DIR)

fclean: clean
	@echo "Removing all Docker resources..."
	@docker system prune -af

re: fclean all

.PHONY: all setup build up down stop start logs status clean fclean re
