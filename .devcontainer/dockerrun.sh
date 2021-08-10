#!/bin/bash
# $1 - USERNAME; $2 - PASSWORD; $3- WORKSPACEFOLDER; $4 - USER_UID; $5 - USER_GID
groupadd --gid $5 $1 
useradd --uid $4 --gid $5 -m $1 -p $(openssl passwd -crypt $2) 
mkdir /opt/${3}
chown $1:$1 /opt/${3}
apt-get update 
apt-get install -y sudo 
apt-get install git
apt-get -y install libxml2-dev libxslt1-dev libldap2-dev libsasl2-dev\
    libtiff5-dev libjpeg62-turbo-dev libopenjp2-7-dev zlib1g-dev\
    libfreetype6-dev liblcms2-dev libwebp-dev libharfbuzz-dev
    libfribidi-dev libxcb1-dev libpq-dev
apt-get -y install postgresql
echo $1 ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$1 
chmod 0440 /etc/sudoers.d/$1
mkdir /home/$1/.ssh
chown $1:$1 /home/$1/.ssh
sudo service postgresql start
sudo -u postgres createuser --superuser $1
sudo -u postgres psql -c "alter role $1 with password '1111'"
chown $1:$1 /home/$1
mkdir /home/$1/ssh_dump