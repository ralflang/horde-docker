#!/bin/bash

# mysql daemon - if needed - 
/usr/sbin/mysqld --basedir=/usr --datadir=/var/lib/mysql --plugin-dir=/usr/lib64/mysql/plugin --user=mysql --log-error=/var/log/mysql/mysqld.log --pid-file=/var/run/mysql/mysql.pid --socket=/var/run/mysql/mysql.sock &
# This is hacky, find a better wait condition
sleep 10
mysqladmin create horde
mysqladmin password horde

# Need to cleanup pid on rerun, otherwise it won't run well
rm /var/run/apache*.pid
# make this PID 1 and stay for good this time 
exec /usr/sbin/start_apache2 -D FOREGROUND

