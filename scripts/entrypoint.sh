#!/bin/bash
set -e

echo "[entrypoint] Scanning for custom addons..."

ADDONS=$(
  find /mnt/extra-addons -maxdepth 1 -mindepth 1 -type d \
    -exec test -f "{}/__manifest__.py" \; -print \
  | xargs -I{} basename {} \
  | paste -sd ',' -
)

if [ -n "$ADDONS" ]; then
  echo "[entrypoint] Installing/updating: $ADDONS"
  exec /entrypoint.sh odoo --update="$ADDONS" --without-demo=all "$@"
else
  echo "[entrypoint] No custom addons found, starting normally."
  exec /entrypoint.sh odoo "$@"
fi
