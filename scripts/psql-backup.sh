#!/bin/bash

BACKUP_DIR="/path/to/backup/directory"
MAX_BACKUPS=35
export RAILS_ENV=test

export PATH="$PATH:$HOME/.rvm/bin"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

eval "$(bundle exec rake credentials:export)"

mkdir -p "$BACKUP_DIR"

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="${BACKUP_DIR}/${DB_NAME}_${TIMESTAMP}.sql.gz"

pg_dump -U "$DB_USER" "$DB_NAME" | gzip > "$BACKUP_FILE" || exit 1

find "${BACKUP_DIR}" -name "${DB_NAME}_*.sql.gz" -type f -printf '%T@ %p\n' \
    | sort -n \
    | head -n -"${MAX_BACKUPS}" \
    | cut -d' ' -f2- \
    | xargs -r rm

exit 0
