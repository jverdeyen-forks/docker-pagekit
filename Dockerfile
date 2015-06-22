FROM debian:jessie

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y nginx \
    php5-fpm \
    php5-json \
    php5-cli \
    php5-mysql \
    php5-curl \
    unzip \
    git \
    supervisor \
    nodejs \
    npm \
    curl

RUN git clone --branch develop git://github.com/pagekit/pagekit.git

RUN chown -R www-data:www-data /pagekit

WORKDIR /pagekit

RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer
RUN composer install

ENV PATH /opt/node/bin/:$PATH
RUN ln -s /usr/bin/nodejs /usr/bin/node
RUN npm install && npm install -g gulp && npm install -g bower
RUN bower install --allow-root
RUN gulp compile

COPY vhost.conf /etc/nginx/sites-enabled/default
COPY supervisor.conf /etc/supervisor/conf.d/supervisor.conf

RUN sed -e 's/;daemonize = yes/daemonize = no/' -i /etc/php5/fpm/php-fpm.conf
RUN sed -e 's/;listen\.owner/listen.owner/' -i /etc/php5/fpm/pool.d/www.conf
RUN sed -e 's/;listen\.group/listen.group/' -i /etc/php5/fpm/pool.d/www.conf
RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf

ADD init.sh /init.sh

VOLUME ["/pagekit/storage", "/pagekit/app/cache"]

EXPOSE 80

CMD ["/init.sh"]