<img src="https://dl.dropbox.com/s/2usz2l4099j7pdy/logo-laravel-docker.png" width=100/>

# laravel-docker
Simple Laravel docker that works! Based on `alpine linux`. 

## Features
- Light weight, based on alpine linux.
- Nginx
- PHP 7.3
- Supercronic
- Supervisor

### How to do `composer install` and `npm/yarn install`?
You can create your own dockerfile and then do this to prepare your dependencies.

```
FROM composer
COPY <your-src-folder> /app
RUN composer install

FROM node
COPY --from=0 /app /app
RUN yarn install

FROM oozman/laravel-docker
COPY --from=1 /app /www
RUN chmod -Rf 777 /www/bootstrap/cache /www/storage
```

### How to build?
After building your dependencies, you can start containerizing your app.

```
docker build -t <your-image-name> .
```
