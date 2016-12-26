FROM opensuse:42.2
RUN zypper ar -G http://download.opensuse.org/repositories/isv:/B1-Systems:/Horde5:/rolling/openSUSE_Leap_42.2/isv:B1-Systems:Horde5:rolling.repo && zypper ref -f && zypper in -ly which php5 apache2-mod_php5 php5-mysql php5-pear php5-pear-channel-horde horde5 horde5-kronolith 
COPY horde-vhost.conf /etc/apache2/vhosts.d/
COPY horde/conf.php /etc/horde/horde/conf.php
RUN a2enmod access_compat ; a2enmod rewrite; a2enmod php5; cp /etc/php5/cli/pear.conf /etc/php5/apache2/
VOLUME ["/usr/share/php5/PEAR/"]
VOLUME ["/var/log"]
VOLUME ["/etc/horde/"]
ENTRYPOINT ["/usr/sbin/start_apache2", "-DFOREGROUND"]
