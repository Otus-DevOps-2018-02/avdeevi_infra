# avdeevi_infra
avdeevi Infra repository

Подключаемся someinternalhost  в одну команду посредством  ssh-proxy:

   ssh -o ProxyCommand='ssh -W %h:%p igor.avdeev@35.204.154.86' igor.avdeev@10.164.0.3

Для подключения к someinternalhost  простой командой вида 

  ssh someinternalhost

добавим в файл ~/.ssh/config следующую секцию:
#---------------------------------------------
Host bastion
    Hostname 35.204.154.86
    user igor.avdeev
    IdentityFile  ~/.ssh/id_rsa

Host someinternalhost
    Hostname 10.164.0.3
    user igor.avdeev
    ProxyCommand ssh -W %h:%p bastion       
#---------------------------------------------

ОПИСАННИЕ ПОЛУЧЕННОЙ КОНФИГУРАЦИИ

bastion_IP = 35.204.154.86
someinternalhost_IP = 10.164.0.3 

