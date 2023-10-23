#!/bin/bash

#Esto muestra todos los comandos que se van ejecutando
set -x 

#Incluimos la variable

source .env

#Actualizamos los repositorios
apt update

#Actualizamos los paquetes de la máquina 

#apt upgrade -y

#Eliminamos descargas previas del repositorio /tmp repositorio temporal.

rm -rf /tmp/iaw-practica-lamp

#Clonamos el repositorio con el codigo fuente de la aplicación

git clone https://github.com/josejuansanchez/iaw-practica-lamp.git /tmp/iaw-practica-lamp

# Movemos el codigo fuente de la aplicacion a /var/www/html 

mv /tmp/iaw-practica-lamp/src/* /var/www/html 

#Configuramos el archivo config.php de la aplicación

sed -i "s/database_name_here/$DB_NAME/" /var/www/html/config.php
sed -i "s/username_here/$DB_USER/" /var/www/html/config.php
sed -i "s/password_here/$DB_PASSWORD/" /var/www/html/config.php

#Modificamos el script de base de datos. Hacemos uso del sed -i

sed -i "s/lamp_db/$DB_NAME/" /tmp/iaw-practica-lamp/db/database.sql


#Importamos el script de la base de datos

mysql -u root < /tmp/iaw-practica-lamp/db/database.sql


#Creamos el usuario de la base de datos y le asignamos privilegios

mysql -u root <<< "DROP USER IF EXISTS '$DB_USER'@'%'"
mysql -u root <<< "CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD'"
mysql -u root <<< "GRANT ALL PRIVILEGES ON $DB_NAME.* TO $DB_USER@'%'"