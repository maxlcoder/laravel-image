# 这里只做 API 部分的处理
# 首先后端 composer 处理
FROM composer AS composer
COPY database/ /app/database/
COPY composer.json composer.lock /app/
RUN cd /app \
    && composer install \
        --optimize-autoloader \
        --ignore-platform-reqs \
        --prefer-dist \
        --no-interaction \
        --no-plugins \
        --no-scripts \
        --no-dev

# PHP
FROM php:7.4-fpm as fpm
ARG LARAVEL_PATH=/var/www/laravel
COPY . ${LARAVEL_PATH}
COPY --from=composer /app/vendor/ ${LARAVEL_PATH}/vendor/
# RUN cd ${LARAVEL_PATH} \
#     && php artisan package:discover \
#     && chown www-data:www-data bootstrap/cache \
#     && chown -R www-data:www-data storage/

COPY docker/entrypoint.sh /usr/local/bin/entrypoint
RUN chmod +x /usr/local/bin/entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint"]