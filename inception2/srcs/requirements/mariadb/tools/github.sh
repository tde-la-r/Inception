#!/bin/bash

MYSQL_DATABASE=theaudb
MYSQL_USER=theau
MYSQL_PASSWORD=GHFH65SDFGf5
MYSQL_ROOT_PASSWORD=BjhG84GFGHG
set -e

# On the first volume mount, create a database in it
if [ ! -e /var/lib/mysql/.firstmount ]; then
    # Initialize a database on the volume and start MariaDB in the background
    mysql_install_db --datadir=/var/lib/mysql --skip-test-db --user=mysql --group=mysql \
        --auth-root-authentication-method=socket >/dev/null 2>/dev/null
    mysqld_safe &
    mysqld_pid=$!

    # Wait for the server to be started, then set up database and accounts
    mysqladmin ping -u root --silent --wait >/dev/null 2>/dev/null
    cat << EOF | mysql --protocol=socket -u root -p=
CREATE DATABASE $MYSQL_DATABASE;
CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';
GRANT ALL PRIVILEGES on *.* to 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
FLUSH PRIVILEGES;
EOF

    # Shut down the temporary server and mark the volume as initialized
    mysqladmin shutdown
    touch /var/lib/mysql/.firstmount
fi

exec mysqld_safe
