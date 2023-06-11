# Программы:
* kdiff
* gitgui
* doxigen
* htop
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
