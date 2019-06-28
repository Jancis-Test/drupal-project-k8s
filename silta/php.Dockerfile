# Dockerfile for the Drupal container.
FROM amazeeio/php:7.3-fpm

COPY --chown=www-data:www-data . /app

