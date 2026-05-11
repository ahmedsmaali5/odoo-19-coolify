FROM odoo:19
COPY ./config/odoo.conf /etc/odoo/odoo.conf
COPY ./custom_addons /mnt/extra-addons
