# ----------------------------------
# Build caddy-server base.
# ----------------------------------
FROM alpine:3.6
LABEL maintainer="Michael Ackley <ackleymi@gmail.com>"

#
# Download caddy.
# ---------------
ARG plugins=tls.dns.route53
ARG license=personal
RUN apk add --no-cache curl && \
    curl --silent --show-error --fail --location \
    --header "Accept: application/tar+gzip, application/x-gzip, application/octet-stream" -o - \
    "https://caddyserver.com/download/linux/amd64?plugins=${plugins}&license=${license}" | \
    tar --no-same-owner -C /usr/bin -xz caddy && \
    chmod 0755 /usr/bin/caddy

#
# Validate install.
# ----------------
RUN /usr/bin/caddy -version
RUN /usr/bin/caddy -plugins

#
# Docker misc.
# ----------------
VOLUME /root/.caddy /srv
4EXPOSE 80 443

#
# Copy web files and caddy config.
# ----------------
COPY Caddyfile /etc/Caddyfile
COPY public /srv


#
# Start-up.
# ----------------
ENTRYPOINT ["/usr/bin/caddy"]
CMD ["--conf", "/etc/Caddyfile", "--log", "stdout"]



#
# Start-up.
# ----------------
ENTRYPOINT ["/usr/bin/caddy"]
CMD ["--conf", "/etc/Caddyfile", "--log", "stdout"]
