gen=$(shell openssl rand -base64 32)

open: setup
	$(eval ip := $(shell boot2docker ip))
	open http://$(ip):3000

setup: .setup

.setup:
	$(eval mysql_root_password := $(gen))
	$(eval wordpress_db_password := $(gen))
	docker run --name wpmysql -e MYSQL_ROOT_PASSWORD="$(mysql_root_password)" -d mysql
	docker build -t sander/mysql-wordpress-init .
	docker run --rm --link wpmysql:mysql -e MYSQL_ROOT_PASSWORD="$(mysql_root_password)" -e WORDPRESS_DB_PASSWORD="$(wordpress_db_password)" sander/mysql-wordpress-init
	docker run --name wp -d --link wpmysql:mysql -e WORDPRESS_DB_USER=wordpress -p 3000:80 -e WORDPRESS_DB_PASSWORD="$(wordpress_db_password)" wordpress
	touch $@

remove:
	docker rm -f wp
	docker rm -f wpmysql
