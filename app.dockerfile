FROM syn:ubuntu-22.04

ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8

RUN mkdir -p /var/www/html

WORKDIR /var/www/html

RUN apt-get update && apt-get upgrade -y

RUN echo "mysql-apt-config mysql-apt-config/select-tools select Enabled" | debconf-set-selections
RUN echo "mysql-apt-config mysql-apt-config/unsupported-platform select abort" | debconf-set-selections
RUN echo "mysql-apt-config mysql-apt-config/preview-component string" | debconf-set-selections
RUN echo "mysql-apt-config mysql-apt-config/repo-url string http://repo.mysql.com/apt" | debconf-set-selections
RUN echo "mysql-apt-config mysql-apt-config/select-server select" | debconf-set-selections
RUN echo "mysql-apt-config mysql-apt-config/repo-codename select jammy" | debconf-set-selections
RUN echo "mysql-apt-config mysql-apt-config/select-preview select Disabled" | debconf-set-selections
RUN echo "mysql-apt-config mysql-apt-config/tools-component string mysql-tools" | debconf-set-selections
RUN echo "mysql-apt-config mysql-apt-config/select-product select" | debconf-set-selections
RUN echo "mysql-apt-config mysql-apt-config/repo-distro select ubuntu" | debconf-set-selections
RUN echo "mysql-apt-config mysql-apt-config/dmr-warning note" | debconf-set-selections

RUN wget -O mysql_all.deb https://dev.mysql.com/get/mysql-apt-config_0.8.25-1_all.deb && dpkg -i mysql_all.deb && rm mysql_all.deb && gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4

RUN apt update && apt install -y mysql-server

RUN mysqld --user mysql & sleep 3 && mysql -u root -e "ALTER USER root@localhost IDENTIFIED WITH mysql_native_password BY '12345678'; CREATE DATABASE app CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci; FLUSH PRIVILEGES;"

RUN add-apt-repository ppa:ondrej/php -y && apt install -y php7.4 php7.4-mysql php7.4-curl php7.4-mbstring apache2

RUN wget -O phpmyadmin.tar.gz https://files.phpmyadmin.net/phpMyAdmin/5.2.1/phpMyAdmin-5.2.1-all-languages.tar.gz && tar -xzvf phpmyadmin.tar.gz && ls -la && mv ./phpMyAdmin-5.2.1-all-languages/* ./  && rm phpmyadmin.tar.gz

