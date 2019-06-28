# Dockerfile for the Drupal container.
FROM amazeeio/php:7.3-fpm

# Add the mysql client, we need it to check the connection to the database.
RUN apk add mysql-client

COPY --chown=www-data:www-data . /app

