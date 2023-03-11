FROM ubuntu:latest

# Update Ubuntu
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y curl && \
    apt-get install -y gnupg

# Install MySQL 8.x
RUN apt-get install -y mysql-server

# Install Node.js 16.x - Check Node from latest LTS version: https://nodejs.org/en/download/
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install -y nodejs

# Create MySQL database and import SQL file
COPY ./table.sql /docker-entrypoint-initdb.d/
RUN sed -i 's/^.*bind-address.*$/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf && \
    #If you dont want connections to linger, keep lines below uncommented
    echo "wait_timeout = 10" >> /etc/mysql/mysql.conf.d/mysqld.cnf && \
    echo "interactive_timeout = 10" >> /etc/mysql/mysql.conf.d/mysqld.cnf && \
    service mysql start && \
    # Create a throwaway database
    mysql -u root -e "CREATE DATABASE mydatabase CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci" && \
    # Creating a user with a blank password
    mysql -u root -e "CREATE USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY ''" && \
    mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION" && \
    mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY ''" && \
    mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION" && \
    mysql -u root -e "FLUSH PRIVILEGES" && \
    #Import the SQL file
    #mysql -u root mydatabase < /docker-entrypoint-initdb.d/table.sql && \
    # Change the database to utf8mb4 if needed
    #mysql -u root -e "ALTER TABLE mydatabase.users CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci" && \
    mysql -u root -e "FLUSH PRIVILEGES" && \
    service mysql stop

# Install Node.js dependencies
COPY package.json /app/
WORKDIR /app
RUN npm install

# Copy Node.js application files
COPY . /app

# Expose port 3000 for the Node.js application and port 3306 for MySQL
EXPOSE 3000 3306

# Start MySQL and Node.js
CMD service mysql start && \
    node index.js  \
    # Sleep forever so you can access the DB from your host. 
    && sleep infinity

# Handle Ctrl+C to end the script and force the container to end
STOPSIGNAL SIGINT
