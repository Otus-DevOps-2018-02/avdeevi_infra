#!/bin/bash

set -e
# Добавляем репу и ключи
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list

# Обновляем апт и ставим монго
apt update
apt install -y mongodb-org
sed -i 's/bindIp:.*$/bindIp: 0.0.0.0/' /etc/mongod.conf 

# Добавляем монго в автозагрузку и стартуем 
systemctl daemon-reload
systemctl enable mongod 
systemctl start mongod 

