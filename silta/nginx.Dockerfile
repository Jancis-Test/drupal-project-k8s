# Dockerfile for building nginx.
FROM wunderio/drupal-nginx:dev-app-prefix

COPY . /app

# comment to change cache key
