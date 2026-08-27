#!/bin/sh
set -e

# 1. 替换 Nginx 配置中的 WEB_LISTEN 环境变量 (输出到 http.d 目录)
envsubst '${WEB_LISTEN}' < /etc/nginx/templates/nginx.conf.template > /etc/nginx/http.d/default.conf

# 2. 如果 /var/www/html 为空或没有 index.php，则自动释放代码
if [ ! -f "/var/www/html/index.php" ]; then
    echo "==> 初始化：正在将 Emlog 源码释放到 /var/www/html ..."
    unzip -q /usr/src/emlog.zip -d /var/www/html/
    chown -R www-data:www-data /var/www/html
    echo "==> 源码释放完成！"
fi

# 3. 启动 PHP-FPM (后台) 与 Nginx (前台)
php-fpm -D
exec nginx -g 'daemon off;'
