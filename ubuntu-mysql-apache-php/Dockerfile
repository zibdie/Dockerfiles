FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV MYSQL_ROOT_PASSWORD=root
ENV TZ=America/New_York

#RUN sed -i 's|http://archive.ubuntu.com/ubuntu|http://azure.archive.ubuntu.com/ubuntu|g' /etc/apt/sources.list && \
#    sed -i 's|http://security.ubuntu.com/ubuntu|http://azure.archive.ubuntu.com/ubuntu|g' /etc/apt/sources.list

RUN apt-get update && apt-get install -y \
    software-properties-common \
    && add-apt-repository -y ppa:ondrej/php \
    && apt-get update && apt-get install -y \
    apache2 \
    libapache2-mod-php8.1 \
    php8.1 \
    php8.1-mysql \
    mysql-server \
    mysql-client \
    python3.10 \
    python3-pip \
    php8.1-curl \
    openssh-server \
    && a2enmod php8.1 \
    && a2enmod rewrite \
    && echo '[mysqld]' > /etc/mysql/conf.d/docker.cnf \
    && echo 'bind-address = 0.0.0.0' >> /etc/mysql/conf.d/docker.cnf \
    && echo 'skip-name-resolve' >> /etc/mysql/conf.d/docker.cnf \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && rm -rf /var/lib/apt/lists/* \
    && echo "ServerName localhost" >> /etc/apache2/apache2.conf \
    && mkdir /var/run/sshd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin without-password/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitEmptyPasswords no/PermitEmptyPasswords yes/' /etc/ssh/sshd_config && \
    sed -i 's/;extension=curl/extension=curl/' /etc/php/8.1/apache2/php.ini && \
    sed -i 's/display_errors = Off/display_errors = On/' /etc/php/8.1/apache2/php.ini && \
    sed -i 's/error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT/error_reporting = E_ALL/' /etc/php/8.1/apache2/php.ini && \
    echo "<?php phpinfo(); ?>" > /var/www/html/phpinfo.php && \
    mv /var/www/html/index.html /var/www/html/apache_default.html

COPY test.sql /tmp/test.sql
COPY db_test.php /var/www/html/db_test.php
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && chmod 755 /tmp/test.sql

EXPOSE 80 3306 22

ENTRYPOINT ["/entrypoint.sh"]
