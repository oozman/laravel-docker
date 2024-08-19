FROM  dunglas/frankenphp:php8.3-alpine

RUN apk --no-cache add sox curl supervisor mariadb-client postgresql-client
RUN install-php-extensions redis pcntl posix soap openssl gmp pdo_odbc json dom pdo zip mysqli sqlite3 pdo_pgsql bcmath gd odbc pdo_mysql pdo_sqlite gettext xml xmlreader xmlwriter simplexml bz2 iconv curl ctype tokenizer opcache fileinfo  session mbstring sockets

# Install supercronic
RUN curl -fsSLO "https://github.com/aptible/supercronic/releases/download/v0.2.26/supercronic-linux-amd64"
RUN chmod +x supercronic-linux-amd64
RUN mv supercronic-linux-amd64 /usr/bin/supercronic

COPY ./config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY ./config/crontab /var/www/crontab

# Set folder permission.
COPY src/ /app

# Be sure to replace "your-domain-name.example.com" by your domain name
#ENV SERVER_NAME=your-domain-name.example.com
# If you want to disable HTTPS, use this value instead:
ENV SERVER_NAME=:80

EXPOSE 80 443

ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

