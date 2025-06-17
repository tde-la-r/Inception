FROM		alpine:3.21

RUN			apk update
RUN			apk upgrade

RUN			apk add mariadb mariadb-client

COPY		tools/mariadb.sh ./mariadb.sh
RUN			chmod +x ./mariadb.sh

ENTRYPOINT	[ "./mariadb.sh" ]
