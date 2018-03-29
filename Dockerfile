FROM php:7.1
MAINTAINER Camoo Sarl <docker@camoo.sarl>

# Install all required extensions
RUN requirements="libmcrypt-dev g++ libicu-dev libmcrypt4 libpng12-0 libpng12-dev libicu52 mysql-client" \
    && apt-get update && apt-get install -y $requirements \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install mcrypt \
    && docker-php-ext-install mbstring \
    && docker-php-ext-install intl \
    && docker-php-ext-install gd \
    && requirementsToRemove="libmcrypt-dev g++ libicu-dev" \
    && apt-get purge --auto-remove -y $requirementsToRemove \
    && rm -rf /var/lib/apt/lists/*

# Install composer
RUN curl -sSL https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && chmod +x /usr/local/bin/composer \
    && apt-get update \
    && apt-get install -y zlib1g-dev git \
    && docker-php-ext-install zip \
    && apt-get purge -y --auto-remove zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Install phpunit
RUN curl --location --output /usr/local/bin/phpunit https://phar.phpunit.de/phpunit.phar \
    && chmod +x /usr/local/bin/phpunit

# Run xdebug installation.
RUN pecl install xdebug \
   && docker-php-ext-enable xdebug

# Run GEOIP installation.
# RUN pecl install geoip && docker-php-ext-enable geoip
