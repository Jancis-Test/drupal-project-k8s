# Dockerfile for the Drupal container.
FROM wunderio/drupal-php-fpm:v0.1.4

RUN apk add --no-cache autoconf libmemcached-dev make g++ \
    && yes '' | pecl install -f memcached \
    && docker-php-ext-enable memcached \
    && apk remove autoconf make g++


COPY --chown=www-data:www-data . /app

