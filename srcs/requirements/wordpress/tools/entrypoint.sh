#!/bin/bash
set -e

cd /var/www/html

WORDPRESS_DB_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/credentials)
WP_USER_PASSWORD=$(cat /run/secrets/credentials)

echo "Waiting for MariaDB..."
until mariadb -h mariadb -u "${WORDPRESS_DB_USER}" \
  -p"${WORDPRESS_DB_PASSWORD}" -e "SELECT 1" > /dev/null 2>&1; do
    echo "MariaDB is not ready yet. Retrying in 2 seconds..."
    sleep 2
done
echo "MariaDB is ready!"

if [ ! -f wp-config.php ]; then
    echo "Downloading WordPress..."
    wp core download --allow-root

    echo "Creating wp-config.php..."
    wp config create \
        --dbname="${WORDPRESS_DB_NAME}" \
        --dbuser="${WORDPRESS_DB_USER}" \
        --dbpass="${WORDPRESS_DB_PASSWORD}" \
        --dbhost="mariadb" \
        --allow-root

    echo "Installing WordPress..."
    wp core install \
        --url="${DOMAIN_NAME}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --allow-root

    echo "Creating additional WordPress user..."
    wp user create "${WP_USER}" "${WP_USER_EMAIL}" \
        --role=author \
        --user_pass="${WP_USER_PASSWORD}" \
        --allow-root

    chown -R www-data:www-data /var/www/html
fi

echo "Starting PHP-FPM in foreground..."
exec php-fpm8.2 -F
