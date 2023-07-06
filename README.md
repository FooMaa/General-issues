# Программы:
* kdiff (для разрешения конфликтов на git)
* gitgui (удобно делать commit и push в git)
* doxigen (для документации)
* htop (диспетчер задач)
* ethtool (глубокая работа с сетевыми интерфейсами)
* ffmpeg (запись видео с экрана из bash)
* fsck (утилита в linux для проверки и восстановления файловой системы)
# Помощь:
## Почему не подключается ПО к БД postgres в Astra Linux:
Файл /etc/parsec/mswitch.conf, параметр zero_if_notfound установить в yes.
В этом случае все пользователи БД, для которых не удалось получить мандатные атрибуты, получат нулевую метку.
## Git submodules:
```
[submodule "src/ltbs/audio/voice_core"]
path = src/libs/audio/voice_core
url = ssh://gitlab@10.1.2.97:2280/1710/voice_core.git
```
## Docker:
![изображение](https://github.com/FooMaa/-/assets/134139503/193ceb04-5ce3-4f98-bbb1-b42e54a81038)

**На Debian Linux ошибка Devices cgroup isn't mounted service docker stop:**
```
cgroupfs-umount
cgroupfs-mount
service docker start 
```
## Права доступа к некоторым файлам Linux:
* ``` id_rsa chmod 0600 ```
## QtCreator c маленькими шрифтами и кнопками на мониторах c высоким разрешением (или мелкопиксельные мониторы):
Для этого надо в .xprofile поставить переменную QT_SCALE_FACTOR и присвоить ей значение > 2, можно поиграть со значением, также можно создать себе скрипт:
```
#!/bin/bash
echo "Starting QtCreator"
export QT_SCALE_FACTOR=2.5
qtcreator
```
## Включить дистанционно ПК:
Поставить в BIOS в разделе Power переключатель Wake on Lan в состояние enable, прописать в Linux:
```
ethtool -s eth0 wol g
```
Чтоб со сторонней машины запустить:
```
wakeonlan 00:0e:2e:b9:cb:ad
```
Чтоб узнать MAC-адрес у сетевой карты, можно восользоваться:
```
ip a
```
## Если в Linux при автозапуске не работают X:
Тогда скрипт или ПО надо выполнять не как daemon или в cron, а создать файл, например, test.desktop по пути:
```
/etc/xdg/autostart
```
## Создать статический IP:
Прописать в /etc/network/interfaces:
```
auto eth0
iface eth0 interface static
address 196.120.134.12
netmask 255.255.255.0
gateway 196.120.0.1
dns-nameservers: 196.120.2.1
dns-nameservers: 196.120.2.15
```