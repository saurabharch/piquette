FROM piquette/caddy:latest
LABEL maintainer="Michael Ackley <ackleymi@gmail.com>"
COPY public /var/www/html
COPY Caddyfile /var/www/html
