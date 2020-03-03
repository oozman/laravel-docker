<img src="https://dl.dropbox.com/s/2usz2l4099j7pdy/logo-laravel-docker.png" width=100/>

# laravel-docker
Simple Laravel docker that works! Based on `alpine linux`. 

## Features
- Light weight, based on alpine linux.
- Nginx
- PHP 7.3
- Supercronic
- Supervisor

## Installation
```
docker build -t <yourimage> .
```

### How to do `composer install` and `npm/yarn install`?
You can separately do this to prepare your dependencies.

```
FROM composer
COPY <your-src> /app
RUN composer install

FROM node
COPY --from=0 /app /app
RUN yarn install
```
