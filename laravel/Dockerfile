FROM php:8.2-cli

# Install system dependencies and PHP extensions
RUN apt-get update && apt-get install -y \
    unzip \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Install Composer
COPY --from=composer:2.7 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

# Install dependencies if composer.json exists (Laravel project already present)
RUN if [ -f "composer.json" ]; then \
    composer install --no-interaction --no-dev --optimize-autoloader; \
    fi

EXPOSE 8000
CMD php artisan serve --host=0.0.0.0 --port=8000
