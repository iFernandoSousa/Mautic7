FROM mautic/mautic:latest

USER root

RUN mkdir -p /var/www/.composer/cache \
    && chown -R www-data:www-data /var/www/.composer

WORKDIR /var/www/html

# Composer 2.2+ blocks plugins unless explicitly allowed. Mautic needs these at
# build time and when installing marketplace plugins at runtime.
RUN COMPOSER_ALLOW_SUPERUSER=1 composer config --no-plugins allow-plugins.composer/installers true \
    && COMPOSER_ALLOW_SUPERUSER=1 composer config --no-plugins allow-plugins.symfony/flex true \
    && COMPOSER_ALLOW_SUPERUSER=1 composer config --no-plugins allow-plugins.mautic/core-composer-scaffold true \
    && COMPOSER_ALLOW_SUPERUSER=1 composer config --no-plugins allow-plugins.mautic/core-project-message true \
    && COMPOSER_ALLOW_SUPERUSER=1 composer config --no-plugins allow-plugins.php-http/discovery true \
    && COMPOSER_ALLOW_SUPERUSER=1 composer require symfony/amazon-mailer:^7.4 etailors/mautic-amazon-ses:^1.0 -W --no-interaction --no-scripts \
    && chown -R www-data:www-data /var/www/html/docroot/plugins/AmazonSesBundle

COPY entrypoint-wrapper.sh /entrypoint-wrapper.sh
RUN chmod +x /entrypoint-wrapper.sh

ENTRYPOINT ["/entrypoint-wrapper.sh"]
