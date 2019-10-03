# copy composer files from composer image
FROM composer:latest AS composer
FROM php:7.3-fpm-alpine
COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN apk add --update icu-dev git curl nano \
    supervisor \
    freetype-dev libjpeg-turbo-dev libpng-dev \
    libxml2-dev tidyhtml-dev libxslt-dev libzip-dev zlib-dev \
#    libmemcached-dev \
#    && pecl install igbinary \
#    && pecl install memcached \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install exif intl mysqli pdo_mysql soap sockets tidy xsl zip \
#    && git clone -b php7 https://github.com/php-memcached-dev/php-memcached /usr/src/php/ext/memcached \
#    && docker-php-ext-configure /usr/src/php/ext/memcached \
#        --disable-memcached-sasl
#    && docker-php-source delete \
    && apk del freetype-dev libjpeg-turbo-dev libpng-dev \
    && rm -rf /tmp/* /var/cache/apk/*
# Configure supervisord
COPY ./supervisord.conf /etc/supervisor/supervisord.conf

RUN apk --no-cache add shadow && \
    usermod -u 1000 www-data; \
    groupmod -g 1000 www-data;


# Switch to use a non-root user from here on
USER www-data

# Add application
WORKDIR /var/www

STOPSIGNAL SIGQUIT
# Expose the port nginx is reachable on
EXPOSE 9000
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]

# PHP-FPM will start with supervisor
#CMD ["php-fpm"]
