*This project has been created as part of the 42 curriculum by yaykhlf.*

# Description
This project builds a small production-like WordPress stack using Docker Compose: Nginx terminates HTTPS, WordPress runs on PHP-FPM, and MariaDB provides the database. The stack is isolated on a private Docker network and uses persistent storage and Docker secrets for credentials.

# Project Description
## Use of Docker and included sources
- Docker Compose orchestrates three services on a dedicated bridge network.
- Each service is built from a custom Dockerfile under srcs/requirements/ with its own configs and entrypoint script.
- Persistent data is stored using Docker volumes configured as bind mounts to /home/yaykhlf/data/wordpress and /home/yaykhlf/data/mariadb
- Secrets are provided via Docker secrets sourced from secrets/*.txt and mounted at /run/secrets inside containers.

## Main design choices
- Separate containers by responsibility (web, app, database) to keep concerns isolated.
- Use minimal Debian base images and only required packages.
- Initialize WordPress at container start with wp-cli to keep installs reproducible.
- Terminate TLS in Nginx with a self-signed certificate for local HTTPS.
- Persist data on the host for easy inspection, backup, and reset.

## Comparisons
### Virtual Machines vs Docker
Virtual machines emulate full hardware and include a guest OS, which is heavier but more isolated. Docker containers share the host kernel, start quickly, and are easier to replicate. This project uses Docker for fast, reproducible service orchestration.

### Secrets vs Environment Variables
Environment variables are convenient for non-sensitive configuration, but they are visible in process listings and container metadata. Docker secrets are stored in files with tighter access controls. This project keeps passwords in secrets while using .env for non-sensitive settings.

### Docker Network vs Host Network
A Docker bridge network isolates containers and provides internal DNS, while host networking removes network isolation. This project uses a dedicated bridge network so services can communicate privately while exposing only Nginx on port 443.

### Docker Volumes vs Bind Mounts
Docker volumes are managed by Docker and are portable, while bind mounts map to explicit host paths and are easy to inspect. This project uses Docker volumes configured as bind mounts to keep data in /home/yaykhlf/data for the 42 environment.

# Instructions
## Prerequisites
- Docker Engine and Docker Compose v2
- Make

## Setup and run
1) Ensure the domain resolves locally by adding this line to /etc/hosts:
   127.0.0.1 yaykhlf.42.fr
2) Create the data directories and build the images:
   make setup && make build
3) Start the stack:
   make up
4) Visit https://yaykhlf.42.fr (accept the self-signed certificate warning).

## Common commands
- Stop services: make down
- View status: make status
- Follow logs: make logs
- Reset data: make clean

# Resources
- Docker docs: https://docs.docker.com/
- Docker Compose file reference: https://docs.docker.com/compose/compose-file/
- Nginx documentation: https://nginx.org/en/docs/
- WordPress documentation: https://wordpress.org/documentation/
- WP-CLI: https://developer.wordpress.org/cli/commands/
- MariaDB documentation: https://mariadb.com/kb/en/documentation/

AI usage:
- None.

See USER_DOC.md for user-facing instructions and DEV_DOC.md for developer details.
