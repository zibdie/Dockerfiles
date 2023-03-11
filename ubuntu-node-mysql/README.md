# ubuntu-node-mysql

Test out your NodeJS script against a dummy MySQL server.

```
docker build -t ubuntu-node-mysql . && docker run -p 3100:3000 -p 3101:3306 ubuntu-node-mysql
```
