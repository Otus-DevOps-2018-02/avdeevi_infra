#!/bin/bash

set -e
# Обновляем APT и устанавливаем  Ruby и Bundler
apt update
apt install -y ruby-full ruby-bundler build-essential

