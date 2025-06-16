FROM		alpine:3.21

RUN			apk update
RUN			apk upgrade

RUN			apk add mariadb mariadb-client

#COPY		conf/mariadb.cnf /etc/my.cnf

COPY		tools/mariadb.sh ./mariadb.sh
RUN			chmod +x ./mariadb.sh

#RUN			mkdir -p /var/lib/mysql /run/mysqld /usr/local/mysql/var
#RUN			chown -R mysql:mysql /var/lib/mysql /run/mysqld /usr/local/mysql/var

ENTRYPOINT	[ "./mariadb.sh" ]
