# Wordpress-Nginx
#
# Version 1.0
FROM ubuntu:14.04
MAINTAINER Martijn van Maurik <martijn@vmaurik.nl>

# Ensure UTF-8
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ABF5BD827BD9BF62
RUN echo deb http://nginx.org/packages/mainline/ubuntu trusty nginx > /etc/apt/sources.list.d/nginx-stable-trusty.list
RUN apt-get update
RUN apt-get -y upgrade

# Install
RUN apt-get install -y nginx php5-fpm php5-mysql php-apc php5-imagick php5-imap php5-mcrypt php5-gd libssh2-php curl

RUN mkdir -p /etc/nginx/sites-enabled

RUN echo "cgi.fix_pathinfo = 0;" >> /etc/php5/fpm/php.ini
ADD nginx.conf /etc/nginx/nginx.conf
ADD nginx-site.conf /etc/nginx/sites-available/default
RUN sed -i -e 's/^listen =.*/listen = \/var\/run\/php5-fpm.sock/' /etc/php5/fpm/pool.d/www.conf

RUN mkdir /data

RUN curl https://wordpress.org/latest.tar.gz | tar zxv -C /data --strip-components=1
RUN chown -R www-data:www-data /data

# Create the section for persistent files
RUN mkdir /var/lib/wordpress

VOLUME ["/var/lib/wordpress/"]

EXPOSE 80
ADD start.sh /start.sh
RUN chmod +x /start.sh
CMD ["/start.sh"]