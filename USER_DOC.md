# User Documentation

## Services provided
- Nginx: HTTPS reverse proxy serving the WordPress site on port 443.
- WordPress (PHP-FPM): application container running the site.
- MariaDB: database backend for WordPress.

## Start and stop the project
- Start everything: make up
- Stop everything: make down
- Stop without removing containers: make stop
- Start existing containers: make start

## Access the website and admin panel
1) Make sure the domain resolves locally:
   127.0.0.1 yaykhlf.42.fr
2) Open the site:
   https://yaykhlf.42.fr
3) Open the WordPress admin panel:
   https://yaykhlf.42.fr/wp-admin

Note: The TLS certificate is self-signed, so your browser will show a warning. You can proceed to the site.

## Locate and manage credentials
- Database password: secrets/db_password.txt
- Database root password: secrets/db_root_password.txt
- WordPress admin and user password: secrets/credentials.txt
- Non-sensitive settings (domain, users, database name): srcs/.env

Update the secret files to change passwords, then restart the stack with make down && make up so containers reload secrets.

## Data location
- WordPress files: /home/yaykhlf/data/wordpress
- MariaDB data: /home/yaykhlf/data/mariadb

These paths are set by LOGIN in the Makefile.

## Check services are running
- Overall status: make status
- Logs: make logs
- Docker Compose status: docker compose -f srcs/docker-compose.yml ps

If the site is not reachable, check that the Nginx container is running and that the domain in /etc/hosts matches yaykhlf.42.fr.
