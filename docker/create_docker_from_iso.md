## Создать docker контейнер из iso образа системы:
Скачиваем нужный iso образ. Монтируем его:
``` bash
sudo mount -o loop $PATH/$FILE.iso /mnt
```
Затем создаем контейнер:
``` bash
sudo tar -C /mnt -c . | sudo docker import - path/name:1.0
```
