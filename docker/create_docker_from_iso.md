## Создать docker контейнер из iso образа системы:
Скачиваем нужный iso образ. Монтируем его:
``` bash
sudo mount -o loop $PATH/$FILE.iso /mnt
```
Ищем файловую систему и архивируем её:
``` bash
sudo tar -czvf filesystem.tar.gz filesystem
```
Затем создаем контейнер:
``` bash
sudo docker import filesystem.tar.gz sys:1.0
```
