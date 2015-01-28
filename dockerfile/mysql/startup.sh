#!/bin/bash
if [ ! -f /var/lib/mysql/ibdata1 ]; then

    mysql_install_db

    /usr/bin/mysqld_safe &
    sleep 10s

    mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO root@'%' IDENTIFIED BY 'cesadmin' WITH GRANT OPTION"
    sleep 2
    killall mysqld
    sleep 10s
fi

/usr/bin/mysqld_safe
