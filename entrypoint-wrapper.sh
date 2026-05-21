#!/bin/bash
set -e

MAUTIC_VOLUME_CONFIG="${MAUTIC_VOLUME_CONFIG:-/var/www/html/config}"
MAUTIC_CONSOLE="${MAUTIC_CONSOLE:-/var/www/html/bin/console}"
MAUTIC_WWW_USER="${MAUTIC_WWW_USER:-www-data}"

# Sync plugins baked into the image with the Mautic database on startup.
# Only the web container needs to do this; cron/worker share the same DB.
if [ "${DOCKER_MAUTIC_ROLE:-}" = "mautic_web" ] \
    && [ -f "${MAUTIC_VOLUME_CONFIG}/local.php" ] \
    && php -r "include('${MAUTIC_VOLUME_CONFIG}/local.php'); exit(!empty(\$parameters['db_driver']) && !empty(\$parameters['site_url']) ? 0 : 1);" 2>/dev/null; then
    su -s /bin/bash "${MAUTIC_WWW_USER}" -c "php ${MAUTIC_CONSOLE} mautic:plugins:reload -nq" || true
    su -s /bin/bash "${MAUTIC_WWW_USER}" -c "php ${MAUTIC_CONSOLE} cache:clear -nq" || true
fi

exec /entrypoint.sh "$@"
