## Создать docker контейнер уже имеющейся системы:
Для систем linux производных от debian, надо поставить debootstrap, он будет копировать базывый образ дистрибутива Debian  в нужный каталог:
```bash
sudo apt-get install debootstrap
```
Нужно создать rootfs для запуска с другого раздела, укажем переменные окружения:
```bash
# target - путь куда будем копировать rootfs
target=/root/mint
# OS - операционная система
OS=ubuntu
# repo - путь до репозитория, склонированного с поставляемого диска
repo=http://$OS.mirror.vu.lt/$OS/
```
Создадим копию roots:
```bash
debootstrap --components=main,contrib,non-free --arch=amd64 wheezy "$target" "$repo"
# debootstrap 1.7_x86-64 astra-folder https://dl.astralinux.ru/astra/stable/1.7_x86-64/repository-main/
# 1.7_x86-64 — имя скрипта из каталога /usr/share/debootstrap/scripts для установки системы. Прежде чем запускать команду, стоит пройти по данному каталогу и найти имя нужного вам скрипта. Это одна из причин, почему стоит создавать docker-образ в той же системе — нужного нам скрипта может не оказаться (маловероятно, что скрипт для Astra Linux будет в Rocky Linux).
# astra-folder — имя локального каталога, куда будет установлена система.
# https://dl.astralinux.ru/astra/stable/1.7_x86-64/repository-main — путь к репозиторию, откуда нужно взять базовые пакеты. Данная опция необязательна, однако в случае с Astra Linux, debootstrap пытается найти пакеты в репозиториях debian, что приводит к ошибке.
# https://www.dmosk.ru/miniinstruktions.php?mini=docker-base-image
```
Затем нужно монтировать блочные устройства (необязательно):
```bash
mount --bind /dev "$target"/dev
mount --bind /dev/pts "$target"/dev/pts
mount --bind /proc "$target"/proc
mount --bind /sys "$target"/sys
```
Chroot - инструмент для изменения корневого каталога диска для запущенного и дочерних процессов. Программа, которая запускается из такого окружения не получит доступ к файлам вне нового корневого каталога. Это новое окружение называется chroot jail. Запускаем команду для этого:
```bash
chroot "$target"
```
Там можно поставить нужные пакеты, приложения, почистить что-то.
Размонтируем блочные устройства (обязательно только, если монтировали):
```bash
umount "$target"/dev
umount "$target"/dev/pts
umount "$target"/proc
umount "$target"/sys
```
Далее надо отправить в архив всё собранное:
```bash
cd "$target"
tar -cf ../mint.tar *
# Следующая команда сразу создаст контейнер docker
# tar -C mint -c . | docker import - mint19:base
```
Отправить архив в docker:
```bash
cat mint.tar | docker import - mint
```
