FROM gliderlabs/alpine:3.3

RUN apk-install mariadb mariadb-client

COPY docker-entrypoint.sh /
EXPOSE 3306
CMD ./docker-entrypoint.sh
