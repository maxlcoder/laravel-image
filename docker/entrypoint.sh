#!/usr/bin/env bash

set -e

cd /var/www/laravel
rm -f public/storage

echo 'migrate'
php artisan migrate --force

echo 'publish'
# 配置发布

echo 'cache'
php artisan config:cache
php artisan route:cache
# 其他 cache
