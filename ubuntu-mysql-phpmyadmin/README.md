# ubuntu-mysql-phpmyadmin

Setup phpmyadmin and MySQL. Useful to easily create, inspect, and modify MySQL tables via a frontend interface (phpMyAdmin) instead of using a MySQL client.

We use Ubuntu as a base to ensure we can install all needed packages from the APT Package Manager.

## Why not use the official `phpmyadmin` or `mysql` docker image?

Because in their examples, they assume we already have a seperate MySQL or phpMyAdmin container that we can just bridge. I would rather have everything in one container if I am doing testing since I will be discaring it after.

## How do I run:

Clone this repository and navigate to folder. Open up your favorite terminal inside the directory and then type:

```
docker build -t ubuntu-mysql-phpmyadmin . && docker run -p 3310:80 -p 3311:3306 ubuntu-mysql-phpmyadmin
```
