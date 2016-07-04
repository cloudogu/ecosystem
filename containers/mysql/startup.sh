#!/bin/bash
mkdir -p /var/run/mysqld
chown -R mysql: /var/run/mysqld

# installation
if [ ! -f /var/lib/mysql/ibdata1 ]; then
    # set stage for health check
    doguctl state installing

    # install database
    mysql_install_db --user=mysql --datadir="/var/lib/mysql"

    # start daemon in background
    /usr/bin/mysqld_safe --user=mysql &

    # create random root password
    MYSQL_ROOT_PASSWORD=$(doguctl random)

    # store the password encrypted
    doguctl config -e password "${MYSQL_ROOT_PASSWORD}"

    # wait until mysql is ready to accept connections
    doguctl wait --port 3306

    # set generated root password
    mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO root@'%' IDENTIFIED BY \"${MYSQL_ROOT_PASSWORD}\" WITH GRANT OPTION;"

    # secure the installation
    # http://www.jbmurphy.com/2011/06/20/mysql_secure_installation/
    mysql -uroot -e "DROP DATABASE test;"
    mysql -uroot -e "DELETE FROM mysql.user WHERE User=\";\""
    mysql -uroot -e "FLUSH PRIVILEGES;"

    # set stage for health check
    doguctl state ready

    # reattach daemon
    wait
else
  # set stage for health check
  doguctl state ready

  # start mysql
  exec /usr/bin/mysqld_safe --user=mysql
fi
