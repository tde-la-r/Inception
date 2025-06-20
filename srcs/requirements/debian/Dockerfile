FROM debian:bullseye

RUN apt update -y && apt upgrade -y
RUN apt-install mariadb mariadb-client

COPY tools/mariadb.sh /mariadb.sh
RUN chmod +x /mariadb.sh

ENTRYPOINT  ["/mariadb.sh"]
