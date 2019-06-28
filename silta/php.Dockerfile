# Dockerfile for the Drupal container.
FROM amazeeio/php:7.3-fpm

RUN set -ex; \
    # Install mysql client
    apk add mysql-client; \
    # Install Drush launcher
    curl -OL https://github.com/drush-ops/drush-launcher/releases/download/${DRUSH_LAUNCHER_VERSION}/drush.phar; \
    chmod +x drush.phar; \
    mv drush.phar /usr/local/bin/drush; \
    \
    # Create directory for shared files
    mkdir -p -m +w /var/www/html/web/sites/default/files; \
    mkdir -p -m +w /var/www/html/private; \
    mkdir -p -m +w /var/www/html/reference-data; \
    chown -R www-data:www-data /var/www/html

# Add composer executables to our path.
ENV PATH="/app/vendor/bin:${PATH}"

COPY --chown=www-data:www-data . /app

