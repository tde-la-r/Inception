#!/bin/sh

echo "[DB CONFIG] Configuring MariaDB..."

if [ ! -d "/run/mysqld" ]; then
	echo "[DB CONFIG] Granting MariaDB daemon run permissions..."
	mkdir -p /run/mysqld
	chown -R mysql:mysql /run/mysqld
fi

echo "[DB CONFIG] Installing MySQL Data Directory..."
mkdir -p ${MARIADB_DATADIR} 
chown -R mysql:mysql ${MARIADB_DATADIR}
mariadb-install-db --basedir=/usr --datadir=${MARIADB_DATADIR} --user=mysql --rpm
echo "[DB CONFIG] MySQL Data Directory done."

echo "[DB CONFIG] Configuring MySQL..."
TMP=/tmp/.tmpfile

echo "USE mysql;" >> ${TMP}
echo "FLUSH PRIVILEGES;" >> ${TMP}
echo "DELETE FROM mysql.user WHERE User='';" >> ${TMP}
echo "DROP DATABASE IF EXISTS test;" >> ${TMP}
echo "DELETE FROM mysql.db WHERE Db='test';" >> ${TMP}
echo "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');" >> ${TMP}
echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MARIADB_ROOT_PASSWORD}';" >> ${TMP}
echo "CREATE DATABASE IF NOT EXISTS ${MARIADB_DATABASE};" >> ${TMP}
echo "CREATE USER '${MARIADB_USER}'@'%' IDENTIFIED BY '${MARIADB_PASSWORD}';" >> ${TMP}
echo "GRANT ALL PRIVILEGES ON ${MARIADB_DATABASE}.* TO '${MARIADB_USER}'@'%' IDENTIFIED BY '${MARIADB_PASSWORD}';" >> ${TMP}
echo "FLUSH PRIVILEGES;" >> ${TMP}

mariadbd --user=mysql --datadir=${MARIADB_DATADIR} --bootstrap < ${TMP}
rm -f ${TMP}
echo "[DB CONFIG] MySQL configuration done."

echo "[DB CONFIG] Allowing remote connections to MariaDB"
sed -i "s|skip-networking|# skip-networking|g" /etc/my.cnf.d/mariadb-server.cnf
sed -i "s|.*bind-address\s*=.*|bind-address=0.0.0.0|g" /etc/my.cnf.d/mariadb-server.cnf

echo "[DB CONFIG] Starting MariaDB daemon on port 3306."
exec mariadbd --datadir=${MARIADB_DATADIR} --user=mysql --console
