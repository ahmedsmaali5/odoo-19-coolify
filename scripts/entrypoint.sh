#!/bin/bash
set -e

# Inject master password from env var into odoo.conf
if [ -n "$ODOO_MASTER_PASSWORD" ]; then
    sed -i "s/^admin_passwd.*/admin_passwd = ${ODOO_MASTER_PASSWORD}/" /etc/odoo/odoo.conf
    # If the line doesn't exist yet, append it
    grep -q "^admin_passwd" /etc/odoo/odoo.conf || \
        echo "admin_passwd = ${ODOO_MASTER_PASSWORD}" >> /etc/odoo/odoo.conf
fi

exec /entrypoint.sh "$@"
