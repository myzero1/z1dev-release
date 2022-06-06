FROM php:7.2-fpm-alpine

MAINTAINER "qxw"

# https://www.cnblogs.com/yangzp/p/14609641.html
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk update\
    && apk add --no-cache \
        bash \
    && mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

# 设置时区为上海
RUN apk add tzdata \
&& ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
&& echo "Asia/Shanghai" > /etc/timezone \
&& apk del tzdata

# ##################### php-fpm,start #####################

# RUN apk add libpng-dev freetype-dev libjpeg-turbo-dev \
#     && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/ \
#     && docker-php-ext-install -j$(nproc) gd \
#     && apk add libzip-dev zip \
#     && docker-php-ext-install zip \
#     && docker-php-ext-install pdo_mysql mysqli exif

RUN apk add libpng-dev freetype-dev libjpeg-turbo-dev libzip-dev zip
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/ 
RUN docker-php-ext-install -j$(nproc) gd zip pdo_mysql exif bcmath

RUN apk add git && git config --global http.sslVerify false
RUN wget https://mirrors.aliyun.com/composer/composer.phar && \cp -rfa composer.phar /usr/bin/composer && chmod +x /usr/bin/composer

# RUN php -v

EXPOSE 9000

CMD ["php-fpm"]