#!/usr/bin/env bash

# default rails environment if not set
RAILS_ENV=${RAILS_ENV:-test}

# path to Rails app root (adjust as needed)
APP_PATH="/var/www/current"
cd "$APP_PATH" || { echo "Invalid APP_PATH"; exit 1; }

# load RVM
export PATH="$PATH:$HOME/.rvm/bin"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# read Ruby version from .ruby-version (error if missing)
if [[ -f ".ruby-version" ]]; then
  RUBY_VERSION=$(< .ruby-version)
else
  echo "ERROR: .ruby-version not found in $APP_PATH"
  exit 1
fi

# select proper Ruby version (do not auto-install)
rvm use "$RUBY_VERSION" --default || { echo "Failed to select Ruby $RUBY_VERSION"; exit 1; }

# fetch DB settings via bin/rails runner
DB_NAME=$(bin/rails runner -e "$RAILS_ENV" "puts Rails.application.credentials.dig(:${RAILS_ENV}, :db_name)")
DB_USER=$(bin/rails runner -e "$RAILS_ENV" "puts Rails.application.credentials.dig(:${RAILS_ENV}, :db_user)")
DB_PASSWORD=$(bin/rails runner -e "$RAILS_ENV" "puts Rails.application.credentials.dig(:${RAILS_ENV}, :db_password)")
DB_HOST=$(bin/rails runner -e "$RAILS_ENV" "puts Rails.application.credentials.dig(:${RAILS_ENV}, :db_host)")
BACKUP_DIR=$(bin/rails runner -e "$RAILS_ENV" "puts Rails.application.credentials.dig(:${RAILS_ENV}, :db_backup_dir)")
MAX_BACKUPS=$(bin/rails runner -e "$RAILS_ENV" "puts Rails.application.credentials.dig(:${RAILS_ENV}, :db_max_backups)")

# ensure password auth over TCP
export PGPASSWORD="$DB_PASSWORD"  # supply to pg
export PGHOST="$DB_HOST"         # force TCP connection

# ensure backup directory exists
mkdir -p "$BACKUP_DIR"

# build filename with timestamp
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="${BACKUP_DIR}/${DB_NAME}_${TIMESTAMP}.sql.gz"

# dump and compress database (use TCP for password auth)
pg_dump -h "$PGHOST" -U "$DB_USER" "$DB_NAME" | gzip > "$BACKUP_FILE" || exit 1

# prune old backups beyond limit
find "$BACKUP_DIR" -name "${DB_NAME}_*.sql.gz" -type f -printf '%T@ %p\n' \
  | sort -n \
  | head -n -"${MAX_BACKUPS}" \
  | cut -d' ' -f2- \
  | xargs -r rm

exit 0  # success
