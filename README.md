docker run -d --name osticket-db \
    --mount source=data,target=/var/lib/mysql \
    -e MYSQL_ROOT_PASSWORD=secret \
    -e MYSQL_DATABASE=osticket_db \
    -e MYSQL_USER=osticket \
    -e MYSQL_PASSWORD=manager_secret mariadb:10


