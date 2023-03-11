FROM ubuntu:latest

ENV MYSQL_USER=root
ENV MYSQL_PASSWORD=

# Install packages required for MySQL and phpMyAdmin
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        mysql-server \
        phpmyadmin \
        apache2 \
        php \
        php-mbstring \
        php-zip \
        php-gd \
        php-json \
        php-curl \
        php-mysql \
        curl

# Disable password prompt for MySQL root user
RUN echo "mysql-server mysql-server/root_password password ''" | debconf-set-selections && \
    echo "mysql-server mysql-server/root_password_again password ''" | debconf-set-selections


# Enable some PHP mods
RUN service apache2 start && \
    phpenmod mbstring && \
    service apache2 stop


# Create MySQL database and import SQL file
COPY ./table.sql /docker-entrypoint-initdb.d/
# Configure MySQL to be accessible from outside the container
RUN sed -i 's/^.*bind-address.*$/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf && \
    #If you dont want connections to linger, keep lines below uncommented
    echo "wait_timeout = 10" >> /etc/mysql/mysql.conf.d/mysqld.cnf && \
    echo "interactive_timeout = 10" >> /etc/mysql/mysql.conf.d/mysqld.cnf && \
    sed -i "/^# general_log_file/s/^# //" /etc/mysql/mysql.conf.d/mysqld.cnf && \
    sed -i "/^# general_log/s/^# //" /etc/mysql/mysql.conf.d/mysqld.cnf && \
    service mysql start && \
    # Create a throwaway database
    mysql -u root -e "CREATE DATABASE mydatabase CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci" && \
    # Creating a user with a blank password
    mysql -u ${MYSQL_USER} -e "CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED WITH mysql_native_password BY '${MYSQL_PASSWORD}'" && \
    mysql -u ${MYSQL_USER} -e "GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_USER}'@'%' WITH GRANT OPTION" && \
    mysql -u ${MYSQL_USER} -e "ALTER USER '${MYSQL_USER}'@'localhost' IDENTIFIED WITH mysql_native_password BY '${MYSQL_PASSWORD}'" && \
    mysql -u ${MYSQL_USER} -e "GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_USER}'@'localhost' WITH GRANT OPTION" && \
    mysql -u ${MYSQL_USER} -e "FLUSH PRIVILEGES" && \
    #Import the SQL file
    mysql -u root mydatabase < /docker-entrypoint-initdb.d/table.sql && \
    # Change the database to utf8mb4 if needed
    mysql -u root -e "ALTER TABLE mydatabase.users CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci" && \
    mysql -u root -e "FLUSH PRIVILEGES" && \
    mysql -u root -e "SET GLOBAL general_log = 'ON';" && \
    mysql -u root -e "SET GLOBAL log_output = 'FILE';" && \
    # Stop the MySQL service
    service mysql stop

    # Enable `AllowNoPassword` in phpMyAdmin
RUN mv /usr/share/phpmyadmin/config.sample.inc.php /usr/share/phpmyadmin/config.inc.php && \
    sed -i "/\$cfg\['Servers'\]\[\$i\]\['AllowNoPassword'\] = false;/d" /usr/share/phpmyadmin/config.inc.php && \
    sed -i "/\$i++/i \$cfg['Servers'][\$i]['AllowNoPassword'] = true;" /usr/share/phpmyadmin/config.inc.php && \
    sed -i "s|// \$cfg\['Servers'\]\[\$i\]\['AllowNoPassword'\] = TRUE;|\$cfg['Servers'][\$i]['AllowNoPassword'] = TRUE;|" /etc/phpmyadmin/config.inc.php && \
    sed -i "s/\$dbuser='phpmyadmin';/\$dbuser='${MYSQL_USER}';/" /etc/phpmyadmin/config-db.php && \
    sed -i "s/^\\\$dbpass='.*/\\\$dbpass='${NEW_DB_PASS}';/" /etc/phpmyadmin/config-db.php

RUN MYSQL_LOG_PATH=$(awk -F'=' '/^log_error/ {print $2}' /etc/mysql/mysql.conf.d/mysqld.cnf) && \
    ln -sf "$MYSQL_LOG_PATH" /var/log/mysql.log

RUN dpkg-reconfigure phpmyadmin

# Configure Apache to serve phpMyAdmin
RUN echo "Include /etc/phpmyadmin/apache.conf" >> /etc/apache2/apache2.conf

# Expose phpMyAdmin and MySQL port
EXPOSE 80 3306

# Start services
CMD service mysql start && \
    service apache2 start && \
    tail -f /var/log/mysql.log
