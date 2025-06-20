#!/bin/sh

MARIADB_DATABASE=theaudb
MARIADB_USERNAME=theau
MARIADB_PASSWORD=inception

set -e #makes the script exit immediately if any command fails
echo "[DB CONFIG] Configuring MariaDB..."

if [ ! -d "/run/mysqld" ]; then
	echo "[DB CONFIG] Granting MariaDB daemon run permissions..."
	mkdir -p /run/mysqld
	chown -R mysql:mysql /run/mysqld
fi

if [ -d "/var/lib/mysql/mysql" ]
then
	echo "[DB CONFIG] MariaDB already configured."
else
	echo "[DB CONFIG] Installing MySQL Data Directory..."
	chown -R mysql:mysql /var/lib/mysql
	mariadb-install-db --basedir=/usr --datadir=/var/lib/mysql --user=mysql --rpm
	echo "[DB CONFIG] MySQL Data Directory done."

	echo "[DB CONFIG] Configuring MySQL..."
	TMP=/tmp/.tmpfile

	echo "CREATE DATABASE ${MARIADB_DATABASE};" >> ${TMP}
	echo "CREATE USER '${MARIADB_USERNAME}'@'%' IDENTIFIED BY '${MARIADB_PASSWORD}';" >> ${TMP}
	echo "GRANT ALL PRIVILEGES ON ${MARIADB_DATABASE}.* TO '${MARIADB_USERNAME}'@'%' IDENTIFIED BY '${MARIADB_PASSWORD}';" >> ${TMP}
	echo "FLUSH PRIVILEGES;" >> ${TMP}

	# Alpine does not come with service or rc-service,
	# so we cannot use: service mysql start
	# We might be able to install with: apk add openrc
	# But we can also manually start and configure the mysql daemon:
	mariadbd -u mysql < ${TMP}
	rm -f ${TMP}
	echo "[DB CONFIG] MySQL configuration done."
fi

echo "[DB CONFIG] Allowing remote connections to MariaDB"
sed -i "s|skip-networking|# skip-networking|g" /etc/my.cnf.d/mariadb-server.cnf
sed -i "s|.*bind-address\s*=.*|bind-address=0.0.0.0|g" /etc/my.cnf.d/mariadb-server.cnf

echo "[DB CONFIG] Starting MariaDB daemon on port 3306."
exec mariadbd -u mysql --console
