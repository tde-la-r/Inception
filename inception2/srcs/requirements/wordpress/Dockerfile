FROM		alpine:3.21

RUN			apk update
RUN			apk upgrade

RUN			apk add php84 php84-fpm
RUN			apk add mariadb-client

# Configure PHP-fpm to listen on internal inception network port 9000
RUN			sed -i 's/listen = 127.0.0.1:9000/listen = 9000/g' /etc/php84/php-fpm.d/www.conf

RUN			apk add curl
RUN			curl -o wp-cli.phar https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN			chmod +x wp-cli.phar

COPY		conf/wordpress.sh ./wordpress.sh
RUN			chmod +x ./wordpress.sh

ENTRYPOINT	./wordpress.sh
