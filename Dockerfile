FROM odoo:19

COPY ./config/odoo.conf /etc/odoo/odoo.conf
COPY ./custom_addons /mnt/extra-addons

USER root
COPY requirements.txt /tmp/requirements.txt

RUN pip install --no-cache-dir -r /tmp/requirements.txt

USER odoo

