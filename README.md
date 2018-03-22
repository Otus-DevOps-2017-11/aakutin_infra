# aakutin_infra
## Homework 05
### Independent tasks
Исследовать способ подключения к internalhost в одну команду из вашего рабочего устройства,
проверить работоспособность найденного решения.

~~~
$ ssh -i ~/.ssh/appuser -A appuser@35.189.192.17 ssh 10.132.0.3
~~~

Доп. задание: Предложить вариант решения для подключения из консоли при помощи команды вида
ssh internalhost из локальной консоли рабочегоустройства, чтобы подключение выполнялось по
алиасу internalhost

~~~
$ cat ~/.ssh/config
Host internalhost
        HostName 10.132.0.3
        ProxyJump appuser@35.189.192.17
        User appuser



$ ssh internalhost
Welcome to Ubuntu 16.04.3 LTS (GNU/Linux 4.13.0-1008-gcp x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  Get cloud support with Ubuntu Advantage Cloud Guest:
    http://www.ubuntu.com/business/services/cloud

0 packages can be updated.
0 updates are security updates.


Last login: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
appuser@someinternalhost:~$
~~~

References:
[(https://en.wikibooks.org/wiki/OpenSSH/Cookbook/Proxies_and_Jump_Hosts)](https://en.wikibooks.org/wiki/OpenSSH/Cookbook/Proxies_and_Jump_Hosts)
	
### Конфигурация сети
Хост bastion, IP: 35.189.192.17, внутр. IP: 10.132.0.2  
Хост: someinternalhost, внутр. IP: 10.132.0.3

