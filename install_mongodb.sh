#!/bin/bash


# Добавляем репу и ключи
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
sudo bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list'

# Обновляем апт и ставим монго
sudo apt update
sudo apt install -y mongodb-org

# Добавляем монго в автозагрузку и стартуем 
sudo systemctl enable mongod 
sudo systemctl start mongod 

