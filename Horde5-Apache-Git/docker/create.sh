#!/bin/bash
## Helper to reduce layers in docker image and make maintaining different flavors easier
#FLAVOR=$1
useradd --uid 1000 -d /srv/git horde
zypper ref
## the good
zypper install -yl glibc-locale git apache2 apache2-mod_php5 php5 php5-pear-channel-horde php5-gettext php5-ctype php5-mysql php5-json php5-pear php5-pdo php5-tokenizer php5-gmp php5-imap php5-dom php5-pear-Date php5-pear-Date_Holidays php5-pear-Date_Holidays_Germany php5-pear-Text_Wiki
## the bad - this needs to go into a flavor as by default it shouldn't be in an image
zypper install -yl vim mc mariadb-client

## the ugly - this needs to go into a flavor
zypper install -yl mariadb

## imp related
zypper install -yl gpg2

cp /etc/php5/cli/pear.conf /etc/php5/apache2/

git config --global http.sslVerify false
mkdir /srv/git
mkdir /srv/www/horde
cd /srv/git
git clone --depth 5 --branch FRAMEWORK_5_2 https://github.com/horde/horde.git horde
git clone --depth 1 https://github.com/horde/horde-support.git horde-support
cp /srv/git/horde/horde/conf.php.dist /srv/git/horde/horde/conf.php



chown -R horde /srv/git/*
chown -R horde /srv/www/horde

# needed for session handler
chown -R horde /var/lib/php5

# Setup local mysql -  we are not particularly interested in this daemon, thus it should not become process 1
/usr/bin/mysql_install_db --datadir="/var/lib/mysql" --socket="/var/run/mysql/mysql.sock" --user=mysql --pid-file=/var/run/mysql/mysql.pid
mkdir /var/run/mysql
chown mysql /var/run/mysql

#/usr/sbin/mysqld --basedir=/usr --datadir=/var/lib/mysql --plugin-dir=/usr/lib64/mysql/plugin --user=mysql --log-error=/var/log/mysql/mysqld.log --pid-file=/var/run/mysql/mysql.pid --socket=/var/run/mysql/mysql.sock &


## git checkout any extra horde libs or apps before this line

cd /srv/git/horde/framework/bin/
cp install_dev.conf.dist install_dev.conf

echo '$horde_git = "/srv/git/horde";' >> install_dev.conf
echo '$web_dir  = "/srv/www/horde";' >> install_dev.conf

./install_dev


cd /etc/apache2
sed -ri s/wwwrun/horde/ /etc/apache2/uid.conf  
cd vhosts.d
cp vhost.template vhost.conf
sed -ri 's|/srv/www/vhosts/dummy-host.example.com|/srv/www/horde|' vhost.conf  
sed -ri 's|dummy-host.example.com|horde.docker|' vhost.conf

a2enmod php5
a2enmod rewrite


zypper clean
