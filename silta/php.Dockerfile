# Dockerfile for the Drupal container.
FROM amazeeio/php:7.3-fpm

RUN apk add --update --no-cache bash

ENV DRUSH_LAUNCHER_VERSION=0.6.0

RUN set -ex; \
    # Install mysql client
    apk add mysql-client; \
    # Install Drush launcher
    curl -OL https://github.com/drush-ops/drush-launcher/releases/download/${DRUSH_LAUNCHER_VERSION}/drush.phar; \
    chmod +x drush.phar; \
    mv drush.phar /usr/local/bin/drush; \
    \
    # Create directory for shared files
    mkdir -p -m +w /app/web/sites/default/files; \
    mkdir -p -m +w /app/private; \
    mkdir -p -m +w /app/reference-data; \
    chown -R www-data:www-data /app

# Add composer executables to our path.
ENV PATH="/app/vendor/bin:${PATH}"

COPY --chown=www-data:www-data . /app

