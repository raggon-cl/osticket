# Usar la imagen base de Ubuntu 22.04
FROM ubuntu:22.04

# Actualizar el sistema e instalar paquetes necesarios
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get -y update && \
    apt-get install -y  apache2 && \
    apt-get install -y php8.1 php8.1-cli php8.1-common php8.1-imap php8.1-redis php8.1-snmp php8.1-xml php8.1-zip php8.1-mbstring php8.1-curl php8.1-mysqli php8.1-gd php8.1-intl php8.1-apcu libapache2-mod-php && \
    apt-get install wget curl unzip && \
    rm -rf /var/lib/apt/lists/*

# Descargar osTicket
RUN wget https://github.com/osTicket/osTicket/releases/download/v1.18.1/osTicket-v1.18.1.zip && \
    mkdir /var/www/html/osticket && \
    unzip osTicket-v1.18.1.zip -d /var/www/html/osticket && \
    cp /var/www/html/osticket/upload/include/ost-sampleconfig.php /var/www/html/osticket/upload/include/ost-config.php && \
    chown -R www-data:www-data /var/www/html/osticket/ && \
    find /var/www/html/. -type d -exec chmod 755 {} \; && \
    find /var/www/html/. -type f -exec chmod 644 {} \;

# Configurar Apache (asegúrate de proporcionar el archivo osticket.conf)
COPY osticket.conf /etc/apache2/sites-available/
RUN a2ensite osticket.conf && \
    a2enmod rewrite && \
    service apache2 restart

# Variables de entorno para la conexión a la base de datos
ENV OSTICKET_DB_HOST=osticket-db
ENV OSTICKET_DB_NAME=osticket_db
ENV OSTICKET_DB_USER=osticket
ENV OSTICKET_DB_PASS=manager_secret

# Modificar el archivo ost-config.php para incluir las variables de entorno
RUN sed -i "s/define('DBHOST', 'localhost');/define('DBHOST', getenv('OSTICKET_DB_HOST'));/" /var/www/html/osticket/upload/include/ost-config.php && \
    sed -i "s/define('DBNAME', 'osticket');/define('DBNAME', getenv('OSTICKET_DB_NAME'));/" /var/www/html/osticket/upload/include/ost-config.php && \
    sed -i "s/define('DBUSER', 'osticket');/define('DBUSER', getenv('OSTICKET_DB_USER'));/" /var/www/html/osticket/upload/include/ost-config.php && \
    sed -i "s/define('DBPASS', 'securepassword');/define('DBPASS', getenv('OSTICKET_DB_PASS'));/" /var/www/html/osticket/upload/include/ost-config.php

# Exponer el puerto 80
EXPOSE 80

# Comando para iniciar Apache
CMD ["apachectl", "-D", "FOREGROUND"]

