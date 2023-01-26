FROM php:8.1-fpm

# Set working directory
WORKDIR /var/www/priceplan

#Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Get latest composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy existing application directory contents to the working directory
COPY . /var/www/priceplan

# Assign permissions of the working directory to the www-data user
# RUN chown -R www-data:www-data \
#        /var/www/priceplan/storage \
#        /var/www/priceplan/bootstrap/cache

# Create system user to run Composer and Artisan Commands
RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN chown -R www-data:www-data /var/www/priceplan/storage /var/www/priceplan/bootstrap/cache

#RUN mkdir -p /home/$user/.composer && \
#    chown -R $user:$user /home/$user

# Expose port 9000 and start php-fpm server (for FastCGI Process Manager)
EXPOSE 9000
CMD ["php-fpm"]