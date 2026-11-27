FROM php:8.2.35-fpm-alpine

# 安装 Nginx、unzip、gettext(提供 envsubst 命令) 以及 PHP 扩展依赖
RUN apk add --no-cache \
    nginx \
    unzip \
    gettext \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    libzip-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) mysqli pdo_mysql gd zip

# 拷贝安全配置、Nginx 模板、入口脚本及 Emlog 压缩包
COPY php-security.ini /usr/local/etc/php/conf.d/
COPY nginx.conf.template /etc/nginx/http.d/default.conf
COPY entrypoint.sh /entrypoint.sh
COPY emlog_pro.zip /usr/src/emlog.zip

RUN chmod +x /entrypoint.sh

EXPOSE 80/tcp
EXPOSE 9000/tcp

ENTRYPOINT ["/entrypoint.sh"]
