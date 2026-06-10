# Developer Documentation

## Prerequisites
- Docker Engine and Docker Compose v2
- Make
- sudo access (for creating /home/yaykhlf/data directories)

## Configuration files
- srcs/.env: domain name and WordPress/MariaDB non-sensitive settings
- secrets/db_password.txt: MariaDB user password
- secrets/db_root_password.txt: MariaDB root password
- secrets/credentials.txt: WordPress admin and author password
- srcs/requirements/nginx/conf/nginx.conf: Nginx TLS and server_name

If you change DOMAIN_NAME in srcs/.env, update server_name in nginx.conf to match.
If you are not using the yaykhlf login, update LOGIN in the Makefile so data paths match your home directory.

## Set up from scratch
1) Update srcs/.env with the desired settings.
2) Set passwords in secrets/*.txt.
3) Ensure the domain resolves locally:
   127.0.0.1 yaykhlf.42.fr
4) Create the data directories:
   make setup
5) Build and launch:
   make build && make up

## Build and launch with Makefile and Docker Compose
- Build images: make build
- Start stack: make up
- Stop stack: make down
- Rebuild from scratch: make re

Equivalent Docker Compose commands:
- docker compose -f srcs/docker-compose.yml build
- docker compose -f srcs/docker-compose.yml up -d
- docker compose -f srcs/docker-compose.yml down

## Manage containers and volumes
- Check status: make status
- Tail logs: make logs
- Exec into a container: docker compose -f srcs/docker-compose.yml exec <service> /bin/bash
- Remove volumes and data: make clean
- Prune all Docker resources: make fclean

## Data storage and persistence
Data is stored on the host in bind-mounted directories:
- WordPress files: /home/yaykhlf/data/wordpress
- MariaDB data: /home/yaykhlf/data/mariadb

These paths are defined in docker-compose.yml as volumes (wp-data and db-data) using the local driver with bind options. Removing containers does not delete the data unless you run make clean or remove the directories manually.
