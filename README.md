docker run -d --name osticket-db \
    --mount source=data,target=/var/lib/mysql \
    -e MYSQL_ROOT_PASSWORD=secret \
    -e MYSQL_DATABASE=osticket_db \
    -e MYSQL_USER=osticket \
    -e MYSQL_PASSWORD=manager_secret mariadb:10
	
docker run -d --name osticket \
    --link osticket-db:mysql \
    --mount type=bind,source="$(pwd)"/target,target=/var/www/html/osticket \
    -e OSTICKET_DB_HOST=osticket-db \
    -e OSTICKET_DB_NAME=osticket_db \
    -e OSTICKET_DB_USER=osticket \
    -e OSTICKET_DB_PASS=manager_secret=manager \
    -p 80:80 \
    osticket:latest
