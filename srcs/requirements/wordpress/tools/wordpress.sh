#!/bin/sh

# Configure WordPress if it isn't already set
if [ ! -f /var/www/html/wp-config.php ]; then
	cd  /var/www/html/
	if [ ! -f index.php ]; then
		echo "[WP_CONFIG] Downloading wordpress..."
		wp-cli.phar core download --allow-root
	fi

	# Create the base configuration file
	echo "[WP_CONFIG] Creating the base configuration file..."
	wp-cli.phar config create \
		--dbname="$MARIADB_DATABASE" \
		--dbuser="$MARIADB_USER" \
		--dbpass="$MARIADB_PASSWORD" \
		--dbhost=mariadb \
		--allow-root
	
	# Create the admin user 
	echo "[WP_CONFIG] Creating the admin user ..."
	wp-cli.phar core install \
		--url="tde-la-r.42.fr" \
		--title="tde-la-r-Inception" \
		--admin_user="$ADMIN_USR" \
		--admin_password="$ADMIN_PWD" \
		--admin_email="$ADMIN_MAIL" \
		--allow-root

	# Create the second user
	echo "[WP_CONFIG] Creating the admin user ..."
	wp-cli.phar user create "$USER_USR" "$USER_MAIL" \
		--role=author \
		--user_pass="$USER_PWD" \
		--allow-root

fi

# Start PhP
php-fpm83 -F
