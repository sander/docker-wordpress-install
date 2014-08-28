#!/bin/bash

if [ -z "$WORDPRESS_DB_PASSWORD" ]; then
    echo >&2 'error: missing required WORDPRESS_DB_PASSWORD environment variable'
    exit 1
fi

echo "Waiting for MySQL…"

MYSQL="mysql -h$MYSQL_PORT_3306_TCP_ADDR -P$MYSQL_PORT_3306_TCP_PORT -uroot -p$MYSQL_ROOT_PASSWORD -e"

RET=1
while [[ RET -ne 0 ]]; do
    sleep 0.5
    $MYSQL "status" > /dev/null 2>&1
    RET=$?
done

echo "Creating WordPress database…"
$MYSQL "create database wordpress"

echo "Granting privileges…"
$MYSQL "grant all privileges on wordpress.* to \"wordpress\" identified by \"$WORDPRESS_DB_PASSWORD\""

echo "Done!"
