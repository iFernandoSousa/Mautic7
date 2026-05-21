FROM mautic/mautic:latest

USER root

RUN mkdir -p /var/www/.composer/cache \
    && chown -R www-data:www-data /var/www/.composer

WORKDIR /var/www/html

RUN COMPOSER_ALLOW_SUPERUSER=1 composer require symfony/amazon-mailer:^7.4 etailors/mautic-amazon-ses:^1.0 -W --no-interaction --no-scripts
