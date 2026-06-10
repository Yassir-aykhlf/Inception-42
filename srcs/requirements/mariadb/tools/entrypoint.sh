#!/bin/bash

set -e

MYSQL_PASSWORD=$(cat /run/secrets/db_password)
MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)

if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then
	echo "Initializing MariaDB data directory..."
	mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null

	echo "Starting temporary MariaDB instance..."
	mariadbd --user=mysql --skip-networking &
	pid=$!

	until mariadb -u root -e "SELECT 1" > /dev/null 2>&1; do
		echo "Waiting for MariaDB to start..."
		sleep 1
	done

	echo "Creating database and users..."
	mariadb -u root << EOF
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'localhost';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF
	echo "Shutting down temporary instance..."
	kill "$pid"
	wait "$pid"
fi

echo "Starting MariaDB in foreground..."
chown -R mysql:mysql /var/lib/mysql
exec mariadbd --user=mysql --datadir=/var/lib/mysql
