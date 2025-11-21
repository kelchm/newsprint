# Use PHP 8.1 with Apache as the base image
FROM php:8.1-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    imagemagick \
    libmagickwand-dev \
    curl \
    libcurl4-openssl-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN pecl install imagick \
    && docker-php-ext-enable imagick \
    && docker-php-ext-install curl

# Enable Apache mod_rewrite (if needed for URL rewriting)
RUN a2enmod rewrite

# Set working directory
WORKDIR /var/www/html

# Copy application files
COPY . /var/www/html/

# Copy custom PHP configuration
COPY php.ini /usr/local/etc/php/conf.d/custom.ini

# Create archive directory and set proper permissions
RUN mkdir -p /var/www/html/archive \
    && chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Create counter.txt file with proper permissions
RUN touch /var/www/html/counter.txt \
    && chown www-data:www-data /var/www/html/counter.txt \
    && chmod 666 /var/www/html/counter.txt

# Expose port 80
EXPOSE 80

# Start Apache in the foreground
CMD ["apache2-foreground"]
