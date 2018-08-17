FROM php:7.2.8-apache

 # Install composer and dependencies
RUN apt-get update && \
    apt-get install -y curl nano git && \
    apt-get install zip unzip && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

 # Install php extentions
RUN apt-get update && apt-get install -y libxml2-dev && docker-php-ext-install soap mbstring

 # Apache config
RUN rm -rf /var/www/html && mkdir -p /var/lock/apache2 /var/run/apache2 /var/log/apache2 /var/www/html && chown -R www-data:www-data /var/lock/apache2 /var/run/apache2 /var/log/apache2 /var/www/html

 # Copy the config file
ADD ./000-default.conf /etc/apache2/sites-available/000-default.conf
 # Set the ENV vars
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2

 # Turn mod_rewrite on
RUN /usr/sbin/a2enmod rewrite

 # Set the file perms correctly on the web root
RUN chown -R www-data:www-data /var/www/

WORKDIR /var/www/html