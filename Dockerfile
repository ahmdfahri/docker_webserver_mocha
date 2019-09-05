FROM ubuntu:16.04

RUN rm /etc/apt/sources.list
COPY src/sources.list /etc/apt/
RUN apt-get update
RUN apt-get -y install curl git libyaml-dev php-igbinary php-msgpack libapache2-mod-fastcgi apache2 libapache2-mod-php7.0 php-cli-prompt php-common php-composer-semver php-composer-spdx-licenses php-gettext php-imagick php-json-schema php-mongodb php-pear php-phpseclib php-symfony-console php-symfony-filesystem php-symfony-finder php-symfony-process php-tcpdf php7.0 php7.0-bz2 php7.0-cli php7.0-curl php7.0-dev php7.0-gd php7.0-intl php7.0-json php7.0-mbstring php7.0-mcrypt php7.0-mysql php7.0-pgsql php7.0-readline php7.0-xml php7.0-zip
RUN curl -s "https://packagecloud.io/install/repositories/phalcon/stable/script.deb.sh" | bash && apt-get -y install php7.0-phalcon
RUN apt-get -y install php7.0-cgi
RUN pecl install redis
RUN pecl install oauth
COPY src/redis.ini /etc/php/7.0/mods-available/redis.ini
COPY src/oauth.ini /etc/php/7.0/mods-available/oauth.ini
COPY src/yaml.ini /etc/php/7.0/mods-available/yaml.ini
COPY src/envvars /etc/apache2/envvars
COPY src/mocha.conf /etc/apache2/sites-available/mocha.conf
RUN phpenmod redis
RUN phpenmod oauth
RUN pecl install yaml
RUN a2ensite mocha
RUN phpenmod yaml
RUN phpenmod msgpack
RUN phpenmod igbinary
RUN a2enmod proxy actions cache expires fastcgi file_cache headers proxy_fcgi proxy_http
RUN update-rc.d apache2 defaults
RUN a2enmod rewrite
RUN a2enmod ssl
RUN useradd -m -s /bin/bash webadmin && mkdir -p /home/webadmin/sites && chown -R webadmin. /home/webadmin/sites
EXPOSE 80 443
ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
