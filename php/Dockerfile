# copy composer files from composer image
FROM composer:latest AS composer
FROM php:7.3-fpm-alpine
COPY --from=composer /usr/bin/composer /usr/bin/composer

# change repository from alpine 3.9 to 3.10
RUN sed -i -e 's/v3\.9/v3.10/g' /etc/apk/repositories
# Install packages see http://dl-cdn.alpinelinux.org/alpine/v3.10/community/x86_64/
#RUN apk add --update --no-cache zip zlib-dev libzip-dev && \
#    docker-php-ext-install mysqli pdo_mysql sockets exif zip posix \
#    && docker-php-ext-configure intl \
#    && docker-php-ext-install intl
RUN docker-php-ext-install mysqli pdo_mysql

RUN apk --update --no-cache add git curl php7 php7-fpm php7-xdebug php7-tidy php7-intl php7-pdo_mysql \
    php7-mysqli php7-sockets php7-exif php7-zip php7-memcached nano

RUN apk --no-cache add shadow && \
    usermod -u 1000 www-data; \
    groupmod -g 1000 www-data;

# Configure nginx
#COPY config/nginx.conf /etc/nginx/nginx.conf

# Configure PHP-FPM
#COPY config/fpm-pool.conf /etc/php7/php-fpm.d/www.conf
#COPY config/php.ini /etc/php7/conf.d/zzz_custom.i
# Configure supervisord
#COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Make sure files/folders needed by the processes are accessable when they run under the nobody user


# Setup document root
#RUN mkdir -p /var/www/html

# Switch to use a non-root user from here on
USER www-data

# Add application
WORKDIR /var/www

STOPSIGNAL SIGQUIT
# Expose the port nginx is reachable on
EXPOSE 9000
CMD ["php-fpm"]

# Let supervisord start nginx & php-fpm
#CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

# Configure a healthcheck to validate that everything is up&running
#HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1:8080/fpm-ping