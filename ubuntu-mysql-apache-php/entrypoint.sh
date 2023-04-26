#!/bin/bash

# Start MySQL
service mysql start

# Wait for MySQL to become available
while ! mysqladmin ping -h localhost -u root --password=${MYSQL_ROOT_PASSWORD} --silent; do
  sleep 1
done

# Configure MySQL
mysql -u root --password=${MYSQL_ROOT_PASSWORD} <<-EOSQL
  DELETE FROM mysql.user WHERE user='root' AND host NOT IN ('localhost', '127.0.0.1', '::1');
  DELETE FROM mysql.user WHERE user='';
  DELETE FROM mysql.db WHERE db='test' OR db='test\\_%';
  FLUSH PRIVILEGES;
  CREATE USER 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
  GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
  FLUSH PRIVILEGES;
  CREATE DATABASE IF NOT EXISTS mydatabase;
  ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${MYSQL_ROOT_PASSWORD}';
EOSQL

# Import the SQL file
mysql -u root --password=${MYSQL_ROOT_PASSWORD} mydatabase < /tmp/test.sql

# Restart Apache to apply configuration changes
service apache2 stop

# Start Apache in the foreground
/usr/sbin/apache2ctl -D FOREGROUND
