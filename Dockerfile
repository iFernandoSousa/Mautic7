FROM mautic/mautic:latest

USER root

RUN mkdir -p /var/www/.composer/cache \
    && chown -R www-data:www-data /var/www/.composer

USER www-data
WORKDIR /var/www/html

RUN composer require symfony/amazon-mailer:^7.4 etailors/mautic-amazon-ses:^1.0 -W --no-interaction --no-scripts
