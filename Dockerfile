FROM php:7.3-fpm

ARG user
ARG uid

# Install  PHP extensions
RUN apt-get update && apt-get install -y \
    # php extencion zip
    libzip-dev \
    # php extencion gd
    libwebp-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libxpm-dev \
    libfreetype6-dev \
    # php extencion xsl
    libxslt1-dev

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd

RUN docker-php-ext-install \
    bcmath \
    intl \
    pdo_mysql \
    simplexml \
    soap \
    xsl \
    zip

# Install composer
RUN apt-get clean && rm -rf /var/lib/apt/lists/*
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create system user to run Commands
RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

# Set working directory
WORKDIR /var/www/shop

USER $user

EXPOSE 9000
CMD ["php-fpm"]





