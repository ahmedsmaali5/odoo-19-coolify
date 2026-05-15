#!/bin/bash
set -e

BACKUP_DIR="/opt/backups" # backup location change it as it fits
DATE=$(date +%Y-%m-%d_%H-%M-%S)
DB_NAME="demotest"          # db name in odoo and not container name
DB_USER="odoo"
KEEP_DAYS=7                      # how many days of backups to keep you can change it dependiing on avaliable space and backup size

ODOO_CONTAINER="odoo-j10asswzxearfii3ked8esjh-075245277823"
DB_CONTAINER="db-j10asswzxearfii3ked8esjh-075245269198"


mkdir -p "$BACKUP_DIR"

echo "[$DATE] Starting backup..."

echo "  → Backing up PostgreSQL..."
docker exec "$DB_CONTAINER" pg_dump -U "$DB_USER" "$DB_NAME" \
  | gzip > "$BACKUP_DIR/db_${DATE}.sql.gz"

echo "  → Backing up filestore..."
docker run --rm \
  --volumes-from "$ODOO_CONTAINER" \
  -v "$(pwd)/backups:/backups" \
  alpine tar czf "/backups/filestore_${DATE}.tar.gz" /var/lib/odoo/filestore

echo "  → Cleaning up backups older than $KEEP_DAYS days..."
find "$BACKUP_DIR" -name "*.gz" -mtime +$KEEP_DAYS -delete

echo "[$DATE] Backup complete."
echo "  DB:        $BACKUP_DIR/db_${DATE}.sql.gz"
echo "  Filestore: $BACKUP_DIR/filestore_${DATE}.tar.gz"
