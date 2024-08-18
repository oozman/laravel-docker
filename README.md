<img src="https://i.imgur.com/qAMmb4C.png" width=100/>

# laravel-docker
Simple Laravel docker image that works! Based on `dunglas/frankenphp`.


Note: This setup can also be used for non-Laravel projects.

## Docker Hub

See: https://hub.docker.com/r/oozman/php/tags

## Features
- Light weight, based on `frankenphp` image
- Caddy
- PHP 8.3
- Supercronic
- Supervisor
- `install-php-extensions` enabled


### Getting Started

Run this command in the root directory of your Laravel project:

```dockerfile
docker run -d -p 8080:80 -v $(pwd):/app oozman/php:8.3-frankenphp
```

Visit your laravel app at `http://localhost:8080`

### SSL Feature

By default, this image is served over HTTP. To enable HTTPS, you can set the following environment variables:

#### Enable HTTPS
```dotenv
# Be sure to replace "your-domain-name.example.com" by your domain name
ENV SERVER_NAME=your-domain-name.example.com
```

#### Disable HTTPS
```dotenv
# If you want to disable HTTPS, use this value instead:
ENV SERVER_NAME=:80
```

### Install PHP extensions
To install and enable PHP extension, use `install-php-extensions` command.

Example:
```dockerfile
RUN install-php-extensions redis ...
```
