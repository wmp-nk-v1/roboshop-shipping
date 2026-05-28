#!/usr/bin/env bash
set -e

: "${DB_HOST:?DB_HOST is required}"
: "${DB_ROOT_PASS:?DB_ROOT_PASS is required}"

echo "Waiting for MySQL at ${DB_HOST}..."
until mysqladmin ping -h "$DB_HOST" -uroot -p"$DB_ROOT_PASS" --silent 2>/dev/null; do
    echo "MySQL not ready, retrying in 2s..."
    sleep 2
done

echo "Running shipping database setup..."
mysql -h "$DB_HOST" -uroot -p"$DB_ROOT_PASS" < /db/schema.sql
mysql -h "$DB_HOST" -uroot -p"$DB_ROOT_PASS" < /db/app-user.sql
echo "Shipping database setup complete"
