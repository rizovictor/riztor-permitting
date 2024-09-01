#!/bin/bash

# Function to check if a PostgreSQL database exists
check_db_exists() {
    sudo -u postgres psql -tAc "SELECT 1 FROM pg_database WHERE datname='$1'" | grep -q 1
}

# Function to check if a PostgreSQL user exists
check_user_exists() {
    sudo -u postgres psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='$1'" | grep -q 1
}

DB_NAME="permits_db"
DB_USER="permits_admin"
DB_PASSWORD="Orion_%0405_5040%_noirO"

# Check if the database already exists
if check_db_exists $DB_NAME; then
    echo "Database '$DB_NAME' already exists. Skipping database setup."
else
    # Switch to the postgres user and execute PostgreSQL commands
    sudo -u postgres psql <<EOF
CREATE DATABASE $DB_NAME;
CREATE USER $DB_USER WITH PASSWORD '$DB_PASSWORD';
ALTER ROLE $DB_USER SET client_encoding TO 'utf8';
ALTER ROLE $DB_USER SET default_transaction_isolation TO 'read committed';
ALTER ROLE $DB_USER SET timezone TO 'UTC';
GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;
\c $DB_NAME;
GRANT ALL PRIVILEGES ON SCHEMA public TO $DB_USER;
\q
EOF

    echo "PostgreSQL database and user setup completed."
fi
