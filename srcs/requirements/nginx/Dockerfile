FROM	debian:bookworm

RUN	apt-get update \
	&& apt-get install -y --no-install-recommends \
	nginx \
	openssl \
	&& rm -fr /var/lib/apt/lists/*

RUN	mkdir -p /etc/nginx/ssl \
	&& openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/nginx/ssl/key.pem \
	-out /etc/nginx/ssl/cert.pem \
	-subj "/C=MA/ST=State/L=City/O=42/OU=42/CN=yaykhlf.42.fr"

COPY	conf/nginx.conf /etc/nginx/conf.d/default.conf

RUN	rm -f /etc/nginx/sites-enabled/default

EXPOSE	443

ENTRYPOINT ["nginx", "-g", "daemon off;"]
