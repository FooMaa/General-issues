## Создать docker контейнер из iso образа системы:
Скачиваем нужный iso образ. Монтируем его:
``` bash
sudo mount -o loop $PATH/$FILE.iso /mnt
```
Ищем файловую систему и выбираем её:
``` bash
cd /mnt
find . -type f | grep filesystem.squashfs
cp filesystem.squashf /home/user/
cd /home/user/
```
Устанавливаем пакет и извлеаем файловую систему:
``` bash
mkdir filesys
sudo unsquashfs -f -d filesys filesystem.squashfs
```
Создаём docker и запускаем:
``` bash
sudo tar -C filesys -c . | sudo docker import - foma/sys:1.0
sudo docker run -it foma/sys:1.0 /bin/bash
```
