#!/bin/bash

# Переходим в домашнюю папку пользователя
cd ~/
# клонируем репу
git clone -b monolith https://github.com/express42/reddit.git
# Ставим зависимости
cd monolith &&  bundle install
# Стартуем приложение
puma -d 
# Выводим на экран информацию о приложении
ps aux | grep puma
