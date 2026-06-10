FROM	debian:bookworm

RUN	apt-get update && apt-get install -y --no-install-recommends \
	php8.2-fpm \
	php8.2-mysql \
	php8.2-curl \
	php8.2-gd \
	php8.2-intl \
	php8.2-mbstring \
	php8.2-xml \
	php8.2-zip \
	curl \
	ca-certificates \
	mariadb-client \
	&& rm -fr /var/lib/apt/lists/*

RUN	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp

RUN	sed -i 's|listen = /run/php/php8.2-fpm.sock|listen = 0.0.0.0:9000|' \
	/etc/php/8.2/fpm/pool.d/www.conf

RUN	mkdir -p /var/www/html && chown -R www-data:www-data /var/www/html

RUN	mkdir -p /run/php

COPY	tools/entrypoint.sh /usr/local/bin/entrypoint.sh

RUN	chmod +x /usr/local/bin/entrypoint.sh

WORKDIR	/var/www/html

EXPOSE	9000

ENTRYPOINT ["entrypoint.sh"]
