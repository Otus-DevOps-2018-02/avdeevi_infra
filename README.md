# avdeevi_infra
avdeevi Infra repository

 Подключаемся someinternalhost  в одну команду посредством  ssh-proxy:
```
   ssh -o ProxyCommand='ssh -W %h:%p igor.avdeev@35.204.154.86' igor.avdeev@10.164.0.3
```
 Для подключения к someinternalhost  простой командой вида 

```
  ssh someinternalhost
```

добавим в файл ~/.ssh/config следующую секцию:

```
Host bastion
    Hostname 35.204.154.86
    user igor.avdeev
    IdentityFile  ~/.ssh/id_rsa

Host someinternalhost
    Hostname 10.164.0.3
    user igor.avdeev
    ProxyCommand ssh -W %h:%p bastion       
```

### Описание полученной конфигурации
```
bastion_IP = 35.204.154.86
someinternalhost_IP = 10.164.0.3 
```

# Доманшее задание номер 5
### Команда для создания  инстанса с работающим приложением с помощью  startup script

```
gcloud compute instances create reddit-app  \
--boot-disk-size=10GB   \
--image-family ubuntu-1604-lts   \
--image-project=ubuntu-os-cloud   \
--machine-type=g1-small   \
--tags puma-server   \
--restart-on-failure \
--metadata-from-file startup-script=startup-script.sh
```
### Команда для создания правила firewall разрешающего работу приложения по 9292 tcp порту

```
gcloud compute firewall-rules create puma-server \
--allow=tcp:9292 \
--direction=INGRESS \
--priority=1000 \
--source-ranges=0.0.0.0/0 \
--target-tags=puma-server 
```
### Информация о приложении 
```
testapp_IP = 35.204.90.81
testapp_port = 9292 
```

# Домашнее задание номер 6

 - Создан парметризированный packer-темплейт для сборки backed-образа с предустановленными  Ruby и MongoDB (ubuntu16.json). 
 - Создан packer-темплейт для сборки immutable сервера с предустановленным приложением и всеми зависимостями (immutable.json).
 - Создан shell-скрипт для настройки и запуска виртуальной машины из образа reddit-full (config-scripts/create-reddit-vm.sh).  

# Домашнее задание номер 7

    - Создана terraform-конфигурация для разворачивания инстанса приложения в GCP. 
    - Определены  input  и output  переменные
    - Описано добавление ключей нескольких пользователей в метаданные-проекта.
    - Проведен эксперимент с добавлением ключей через terraform и веб-интерфейс GCP, выяснили что эти два способа конфликтуют между собой: терраформ перезатирает ключи добавленные в веб-интерфейсе. 
    - Описано разворачивание балансировщика в файле  lb.tf . Конфигурация разворачивания инстансов дополнена переменной count.


# Домашнее задание номер 8
 - Конфирурация терраформа разделена на модули -  app, db, vpc, для модулей определены входные и выходные переменные. 
 - Созданы терраформ конфиги для двух окружений  - stage и prod. Добавлен параметр  env  в модули. 
 - Проведен эксперимент с использованием реестра модулей. 
 - Настроено хранение стейт-файла в удаленном бекенде с использованием GCS.
 - Настроена работа provisioner для деплоя приложения, файлы  провизионеров перенесены в папки модулей.
 - Дополнен шаблон packer для DB-серверов  и пересобран образ для того чтобы  MongoDB биндилась при старте на все интерфейсы а не только localhost.
 - Доработаны модуль  app-сервера, так чтобы при provisioning корректно выставлялcя адрес DB-сервера в переменной окружения в конфигурационном файле и приложение видело базу. 

# Домашнее задание номер 9
 - Установлен  ansible на локальном компьютере
 - Созданы  inventory файлы в форматах  ini, yaml и json
 - Cоздан ansible.cfg для проекта
 - Сделан простой плейбук clone.yml для клонирования репозитария на app сервер.
 - Проведен эксперимент с удалением репы на апп сервере и проигрывании плейбука  clone.yml. Если репы нет, при накатывании плейбука, репа создается, отчет ansible (произведено одно изменение):
```
appserver                  : ok=2    changed=1    unreachable=0    failed=0   
```
 - Выполнено задание со *, сделан простой bash скрипт который выдает на  stdout наш  inventory.json . Пример использования:
```
ansible all -m ping -i dynamic.sh
```


