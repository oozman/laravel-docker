FROM php:8.3-fpm-alpine3.19

# Update certificates
RUN apk update && apk --no-cache add ca-certificates

# PHP Extension installer
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions

# Install dependencies
RUN apk --no-cache add nginx supervisor curl mariadb-client postgresql-client
RUN install-php-extensions redis pcntl posix soap openssl gmp pdo_odbc json dom pdo zip mysqli sqlite3 pdo_pgsql bcmath gd odbc pdo_mysql pdo_sqlite gettext xml xmlreader xmlwriter simplexml bz2 iconv curl ctype tokenizer opcache fileinfo  session mbstring

# Install supercronic
RUN curl -fsSLO "https://github.com/aptible/supercronic/releases/download/v0.2.26/supercronic-linux-amd64"
RUN chmod +x supercronic-linux-amd64
RUN mv supercronic-linux-amd64 /usr/bin/supercronic

# Symlink php8 to php
RUN ln -s /usr/bin/php8 /usr/bin/php

# Add user
RUN adduser -D -g 'www' www
RUN mkdir /www
RUN chown -R www:www /var/lib/nginx
RUN chown -R www:www /www

# Set ENV
ENV PHP_FPM_USER="www"
ENV PHP_FPM_GROUP="www"
ENV PHP_FPM_LISTEN_MODE="0660"
ENV PHP_MEMORY_LIMIT="512M"
ENV PHP_MAX_UPLOAD="50M"
ENV PHP_MAX_FILE_UPLOAD="200"
ENV PHP_MAX_POST="100M"
ENV PHP_DISPLAY_ERRORS="On"
ENV PHP_DISPLAY_STARTUP_ERRORS="On"
ENV PHP_ERROR_REPORTING="E_COMPILE_ERROR\|E_RECOVERABLE_ERROR\|E_ERROR\|E_CORE_ERROR"
ENV PHP_CGI_FIX_PATHINFO=0

# Modify www.conf
RUN sed -i "s|;listen.owner\s*=\s*nobody|listen.owner = ${PHP_FPM_USER}|g" /usr/local/etc/php-fpm.d/www.conf
RUN sed -i "s|;listen.group\s*=\s*nobody|listen.group = ${PHP_FPM_GROUP}|g" /usr/local/etc/php-fpm.d/www.conf
RUN sed -i "s|;listen.mode\s*=\s*0660|listen.mode = ${PHP_FPM_LISTEN_MODE}|g" /usr/local/etc/php-fpm.d/www.conf
RUN sed -i "s|user\s*=\s*nobody|user = ${PHP_FPM_USER}|g" /usr/local/etc/php-fpm.d/www.conf
RUN sed -i "s|group\s*=\s*nobody|group = ${PHP_FPM_GROUP}|g" /usr/local/etc/php-fpm.d/www.conf
RUN sed -i "s|;log_level\s*=\s*notice|log_level = notice|g" /usr/local/etc/php-fpm.d/www.conf #uncommenting line

# Modify php.ini-development
RUN sed -i "s|display_errors\s*=\s*Off|display_errors = ${PHP_DISPLAY_ERRORS}|i" /usr/local/etc/php/php.ini-development
RUN sed -i "s|display_startup_errors\s*=\s*Off|display_startup_errors = ${PHP_DISPLAY_STARTUP_ERRORS}|i" /usr/local/etc/php/php.ini-development
RUN sed -i "s|error_reporting\s*=\s*E_ALL & ~E_DEPRECATED & ~E_STRICT|error_reporting = ${PHP_ERROR_REPORTING}|i" /usr/local/etc/php/php.ini-development
RUN sed -i "s|;*memory_limit =.*|memory_limit = ${PHP_MEMORY_LIMIT}|i" /usr/local/etc/php/php.ini-development
RUN sed -i "s|;*upload_max_filesize =.*|upload_max_filesize = ${PHP_MAX_UPLOAD}|i" /usr/local/etc/php/php.ini-development
RUN sed -i "s|;*max_file_uploads =.*|max_file_uploads = ${PHP_MAX_FILE_UPLOAD}|i" /usr/local/etc/php/php.ini-development
RUN sed -i "s|;*post_max_size =.*|post_max_size = ${PHP_MAX_POST}|i" /usr/local/etc/php/php.ini-development
RUN sed -i "s|;*cgi.fix_pathinfo=.*|cgi.fix_pathinfo= ${PHP_CGI_FIX_PATHINFO}|i" /usr/local/etc/php/php.ini-development

# Modify php.ini-production
RUN sed -i "s|display_errors\s*=\s*Off|display_errors = ${PHP_DISPLAY_ERRORS}|i" /usr/local/etc/php/php.ini-production
RUN sed -i "s|display_startup_errors\s*=\s*Off|display_startup_errors = ${PHP_DISPLAY_STARTUP_ERRORS}|i" /usr/local/etc/php/php.ini-production
RUN sed -i "s|error_reporting\s*=\s*E_ALL & ~E_DEPRECATED & ~E_STRICT|error_reporting = ${PHP_ERROR_REPORTING}|i" /usr/local/etc/php/php.ini-production
RUN sed -i "s|;*memory_limit =.*|memory_limit = ${PHP_MEMORY_LIMIT}|i" /usr/local/etc/php/php.ini-production
RUN sed -i "s|;*upload_max_filesize =.*|upload_max_filesize = ${PHP_MAX_UPLOAD}|i" /usr/local/etc/php/php.ini-production
RUN sed -i "s|;*max_file_uploads =.*|max_file_uploads = ${PHP_MAX_FILE_UPLOAD}|i" /usr/local/etc/php/php.ini-production
RUN sed -i "s|;*post_max_size =.*|post_max_size = ${PHP_MAX_POST}|i" /usr/local/etc/php/php.ini-production
RUN sed -i "s|;*cgi.fix_pathinfo=.*|cgi.fix_pathinfo= ${PHP_CGI_FIX_PATHINFO}|i" /usr/local/etc/php/php.ini-production

# Set default php.ini
RUN mv /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini

# Copy nginx.conf
COPY config/nginx.conf /etc/nginx/nginx.conf

# Copy crontab
COPY config/crontab /var/www/crontab

# Copy supervisord.conf
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80

ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]