#!/bin/bash

# mysql daemon - if needed - 
/usr/sbin/mysqld --basedir=/usr --datadir=/var/lib/mysql --plugin-dir=/usr/lib64/mysql/plugin --user=mysql --log-error=/var/log/mysql/mysqld.log --pid-file=/var/run/mysql/mysql.pid --socket=/var/run/mysql/mysql.sock &
# This is hacky, find a better wait condition
sleep 10
## Either use parameters from docker run or externalize base DB setup
mysqladmin create horde
mysql -e "GRANT ALL ON horde.* to horde@localhost identified by 'horde';"
## lock root
mysqladmin password horde

## For some reason, horde-db-migrate needs more than one run when starting from blank. It's supposed to be idempotent so running it three times won't hurt
/srv/git/horde/horde/bin/horde-db-migrate
/srv/git/horde/horde/bin/horde-db-migrate
/srv/git/horde/horde/bin/horde-db-migrate

# Need to cleanup pid on rerun, otherwise it won't run well
rm /var/run/apache*.pid
# make this PID 1 and stay for good this time 
exec /usr/sbin/start_apache2 -D FOREGROUND

