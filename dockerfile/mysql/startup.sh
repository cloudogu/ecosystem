#!/bin/bash
if [ ! -f /var/lib/mysql/ibdata1 ]; then

    mysql_install_db

    /usr/bin/mysqld_safe &
    sleep 10s
    source /etc/ces/functions.sh
    MYSQL_ROOT_PASSWORD=$(create_or_get_ces_pass mysql_root)
    mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO root@'%' IDENTIFIED BY \"${MYSQL_ROOT_PASSWORD}\" WITH GRANT OPTION"
    sleep 2
    killall mysqld
    sleep 10s
fi

/usr/bin/mysqld_safe
