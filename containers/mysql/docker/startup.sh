#!/bin/bash
mkdir -p /var/run/mysqld
chown -R mysql: /var/run/mysqld
if [ ! -f /var/lib/mysql/ibdata1 ]; then
    mysql_install_db --user=mysql --datadir="/var/lib/mysql"
    /usr/bin/mysqld_safe &
    sleep 10s
    source /etc/ces/functions.sh
    MYSQL_ROOT_PASSWORD=$(create_or_get_ces_pass mysql_root)
    # http://www.jbmurphy.com/2011/06/20/mysql_secure_installation/
    mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO root@'%' IDENTIFIED BY \"${MYSQL_ROOT_PASSWORD}\" WITH GRANT OPTION;"
    mysql -uroot -e "DROP DATABASE test;"
    mysql -uroot -e "DELETE FROM mysql.user WHERE User=\";\""
    mysql -uroot -e "FLUSH PRIVILEGES;"
    sleep 2
    killall mysqld
    sleep 10s
fi

/usr/bin/mysqld_safe --user=mysql
