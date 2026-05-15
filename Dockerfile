FROM odoo:19

COPY ./config/odoo.conf /etc/odoo/odoo.conf
COPY ./custom_addons /mnt/extra-addons
COPY ./enterprise_addons /mnt/enterprise-addons


USER root
COPY requirements.txt /tmp/requirements.txt

RUN python3 -m pip install --no-cache-dir --break-system-packages -r /tmp/requirements.txt


USER odoo

