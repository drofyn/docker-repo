FROM php:7.4-fpm-alpine

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

# 彻底删掉官方默认的 zz-docker.conf（消除 9000 端口监听的根源）
RUN rm -f /usr/local/etc/php-fpm.d/zz-docker.conf

# 创建一个字典序靠后的配置文件，强制指定 Socket 通信与权限
RUN echo '[global]' > /usr/local/etc/php-fpm.d/zzz-socket.conf && \
    echo 'daemonize = no' >> /usr/local/etc/php-fpm.d/zzz-socket.conf && \
    echo '[www]' >> /usr/local/etc/php-fpm.d/zzz-socket.conf && \
    echo 'listen = /var/run/php-fpm.sock' >> /usr/local/etc/php-fpm.d/zzz-socket.conf && \
    echo 'listen.owner = www-data' >> /usr/local/etc/php-fpm.d/zzz-socket.conf && \
    echo 'listen.group = www-data' >> /usr/local/etc/php-fpm.d/zzz-socket.conf && \
    echo 'listen.mode = 0660' >> /usr/local/etc/php-fpm.d/zzz-socket.conf

# 拷贝安全配置、Nginx 模板、入口脚本及 Emlog 压缩包
COPY php-security.ini /usr/local/etc/php/conf.d/
COPY nginx.conf.template /etc/nginx/templates/
COPY entrypoint.sh /entrypoint.sh
COPY emlog_pro.zip /usr/src/emlog.zip

RUN chmod +x /entrypoint.sh

# 默认设置 Web 端口为 8080（可在 docker-compose 中修改）
ENV WEB_LISTEN=80

ENTRYPOINT ["/entrypoint.sh"]
