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

## Homework 06
### Independent tasks
Команды по настройке системы и деплоя приложения нужно завернуть
в баш скрипты, чтобы не вбивать эти команды вручную:
 * скрипт **install_ruby.sh** - должен содержать команды по установке руби.
 * скрипт **install_mongodb.sh** - должен содержать команды по установке MongoDB
 * скрипт **deploy.sh** должен содержать команды скачивания кода, установки зависимостей через bundler и запуск приложения.


### Additional task 1
В качестве доп. задания используйте созданные ранее скрипты
для создания **startup script**, который будет запускаться при
создании инстанса. Передавать startup скрипт необходимо как
доп опцию уже использованной ранее команде gcloud. В
результате применения данной команды gcloud мы должны
получать инстанс с уже запущенным приложением.
Startup скрипт необходимо закомитить, а используемую
команду gcloud добавить в описание репозитория (README.md)
Также можно попробовать использовать **startup-script-url** для указания загрузить скрипт из URL.

**Run startup script from local dir**
~~~
$ gcloud compute instances create reddit-app\
>   --boot-disk-size=10GB \
>   --image-family ubuntu-1604-lts \
>   --image-project=ubuntu-os-cloud \
>   --machine-type=g1-small \
>   --tags puma-server \
>   --restart-on-failure \
>   --metadata-from-file startup-script=reddit_startup.sh
WARNING: You have selected a disk size of under [200GB]. This may result in poor I/O performance. For more information, see: https://developers.google.com/compute/docs/disks#performance.
NAME        ZONE            MACHINE_TYPE  PREEMPTIBLE  INTERNAL_IP  EXTERNAL_IP   STATUS
reddit-app  europe-west1-d  g1-small                   10.132.0.4   X.X.X.X  RUNNING
Created [https://www.googleapis.com/compute/v1/projects/infra-XXXXXXX/zones/europe-west1-d/instances/reddit-app].
~~~
**Delete instance**
~~~
$ gcloud compute instances delete reddit-app --quiet
Deleted [https://www.googleapis.com/compute/v1/projects/infra-XXXXXXX/zones/europe-west1-d/instances/reddit-app].
~~~
**Upload startup-script to metadata bucket**
~~~
$ gsutil.cmd mb gs://metadata_bucket
Creating gs://metadata_bucket/...

$ gsutil.cmd cp reddit_startup.sh gs://metadata_bucket/
Copying file://reddit_startup.sh [Content-Type=application/x-sh]...
- [1 files][  1.0 KiB/  1.0 KiB]
Operation completed over 1 objects/1.0 KiB.

$ gsutil.cmd ls -l gs://metadata_bucket/
      1070  2018-03-21T08:43:55Z  gs://metadata_bucket/reddit_startup.sh
TOTAL: 1 objects, 1070 bytes (1.04 KiB)
~~~
**Run startup-script from url**
~~~
$ gcloud compute instances create reddit-app\
>   --boot-disk-size=10GB \
>   --image-family ubuntu-1604-lts \
>   --image-project=ubuntu-os-cloud \
>   --machine-type=g1-small \
>   --tags puma-server \
>   --restart-on-failure \
>   --metadata startup-script-url=https://storage.googleapis.com/metadata_bucket/reddit_startup.sh
WARNING: You have selected a disk size of under [200GB]. This may result in poor I/O performance. For more information, see: https://developers.google.com/compute/docs/disks#performance.
NAME        ZONE            MACHINE_TYPE  PREEMPTIBLE  INTERNAL_IP  EXTERNAL_IP   STATUS
reddit-app  europe-west1-d  g1-small                   10.132.0.4   X.X.X.X  RUNNING
Created [https://www.googleapis.com/compute/v1/projects/infra-XXXXXXX/zones/europe-west1-d/instances/reddit-app].
~~~
**Delete metadata bucket and reddit-app instance**
~~~
$ gsutil.cmd rm -r gs://metadata_bucket
Removing gs://metadata_bucket/reddit_startup.sh#1521629422156366...
/ [1 objects]
Operation completed over 1 objects.                                             
Removing gs://metadata_bucket/...

$ gcloud compute instances delete reddit-app --quiet
Deleted [https://www.googleapis.com/compute/v1/projects/infra-XXXXXXX/zones/europe-west1-d/instances/reddit-app].
~~~
### Additional task 2
 * Удалите созданное через веб интерфейс правило для работы приложения **default-puma-server**.
 * Создайте аналогичное правило из консоли с помощью _gcloud_.
 * Используемую команду _gcloud_ необходимо добавить в описание репозитория (README.md)

 **Show current firewall rules** 
~~~
$ gcloud compute firewall-rules list                                                             NAME                    NETWORK  DIRECTION  PRIORITY  ALLOW                         DENY
default-allow-http      default  INGRESS    1000      tcp:80
default-allow-https     default  INGRESS    1000      tcp:443
default-allow-icmp      default  INGRESS    65534     icmp
default-allow-internal  default  INGRESS    65534     tcp:0-65535,udp:0-65535,icmp
default-allow-rdp       default  INGRESS    65534     tcp:3389
default-allow-ssh       default  INGRESS    65534     tcp:22
default-puma-server     default  INGRESS    1000      tcp:9292
vpn-11127               default  INGRESS    1000      udp:11127

To show all fields of the firewall, please show in JSON format: --format=json
To show all fields in table format, please see the examples in --help.


~~~
**Deleting firewall rule**
~~~
$ gcloud compute firewall-rules delete default-puma-server --quiet
Deleted [https://www.googleapis.com/compute/v1/projects/infra-XXXXXXX/global/firewalls/default-puma-server]
~~~

~~~
$ gcloud compute firewall-rules list
NAME                    NETWORK  DIRECTION  PRIORITY  ALLOW                         DENY
default-allow-http      default  INGRESS    1000      tcp:80
default-allow-https     default  INGRESS    1000      tcp:443
default-allow-icmp      default  INGRESS    65534     icmp
default-allow-internal  default  INGRESS    65534     tcp:0-65535,udp:0-65535,icmp
default-allow-rdp       default  INGRESS    65534     tcp:3389
default-allow-ssh       default  INGRESS    65534     tcp:22
vpn-11127               default  INGRESS    1000      udp:11127

To show all fields of the firewall, please show in JSON format: --format=json
To show all fields in table format, please see the examples in --help.

~~~
**Create new firewall rule with gcloud commnad**
~~~
gcloud compute firewall-rules create default-puma-server --allow tcp:9292 --description "Allow incoming traffic on TCP port 9292" --direction INGRESS
~~~
**List firewall rules table**
~~~
$ gcloud compute firewall-rules list
NAME                    NETWORK  DIRECTION  PRIORITY  ALLOW                         DENY
default-allow-http      default  INGRESS    1000      tcp:80
default-allow-https     default  INGRESS    1000      tcp:443
default-allow-icmp      default  INGRESS    65534     icmp
default-allow-internal  default  INGRESS    65534     tcp:0-65535,udp:0-65535,icmp
default-allow-rdp       default  INGRESS    65534     tcp:3389
default-allow-ssh       default  INGRESS    65534     tcp:22
default-puma-server     default  INGRESS    1000      tcp:9292
vpn-11127               default  INGRESS    1000      udp:11127

To show all fields of the firewall, please show in JSON format: --format=json
To show all fields in table format, please see the examples in --help.
~~~
