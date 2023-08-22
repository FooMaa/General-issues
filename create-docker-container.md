## Создать docker контейнер на базе vmdk:
Установить пакеты и добавить себя в группу docker (в новых версиях docker.io может быть заменен на docker-ce):
```bash
sudo apt-get install docker.io
sudo apt-get install cgroupfs-mount
sudo apt-get install qemu-utils
sudo usermod -a -G docker $(whoami)
```
Важно, чтоб установить контейнер, должна уже быть установлена вирутальная машина vmdk, для докера важно наличие файловой системы.
Затем нужно перейти в папку с вирутальными машинами и преобразовать vmdk в необработанный файл raw:
```bash
cd vmware
qemu-img convert -O raw mint.vmdk mint.raw
```
Затем следует созадать путь, куда мы будем монтировать:
```bash
mkdir mnt
```
Затем важно узнать offset на raw файле (нужна циферки из второй строки Disk /home/user/mint.raw: 1234567890):
```bash
sudo parted -s mint.raw unit b print
```
Далее монтируем файл raw в созданную директорию, это прокатит, если раздел простой (ext, fat):
```bash
sudo mount -o loop,ro,offset=12345678 container/image.raw /mnt
```
Если не примонтировалось, или используется LVM, то нужно зайти в synaptic и найти пакет losetup, поставить его:
```bash
synaptic-pkexec
```
В synaptic ищем losetup, ставим пакет golang-gopkg*losetup.v1-dev.
Настраиваем loop-устройство:
```bash
sudo losetup /dev/loop0 mint.raw
```
Для генерации утройства разделов нужно, чтоб ядро сканировало содержимое loop-устройства, вручную укажем это:
```bash
sudo partx -u /dev/loop0
```
Если есть возможность посмотреть сгенерированные сопоставления с помощью lvmdiskscan:
```bash
sudo lvmdiskscan
```
Если же данной утилиты по каким-то причинам нет, то можно найти loop-устройства:
```bash
sudo lsblk -p
sudo fdisk -l
```
В выведенной информации нам надо по размеру loop-устройства понять, какое имя имеет корневой раздел, затем монтируем этот раздел:
```bash
sudo mount /dev/loop0p1 ./mnt
```
Важно выбирать именно раздел loop с файловой системой. Возможны ошибки при монтировании, при ошибке следует сделать:
```bash
# Удалим loop девайс
sudo losetup -d /dev/loop0
# Примонтируем с разбором разделов
sudo losetup -P /dev/loop0 mint.raw
# sudo partx -u делать уже не стоит, опция "-P" сама разберет разделы
sudo mount /dev/loop0p5 mnt
# Затем делаем пол порядку
```
Затем можно зайти в папку mnt. Там должна появиться файловая система нужного образа. Затем надо его архивировать:
```bash
tar -C mnt -czf mint.tar.gz .
```
Начинаем работу с докером, создадим образ: 
```bash
sudo docker import mint.tar.gz mint19.6:1.0
```
В интернете предлагают еще другие команды создания образа, можно пробовать одну из этих, так же можно поиграться с ключами команды:
```bash
sudo docker import -ti --rm -v $(pwd)/work mint:1.0 make -C work
```
Затем посмотрим IMAGE ID у созданного докера, берем из:
```bash
sudo docker images
```
Стартуем docker в виде терминала с помощью IMAGE ID или полного имени, команда на выбор:
```bash
sudo docker run -it 12b132b1f213f /bin/bash
sudo docker run -it mint:1.0 /bin/bash
```
В процессе возникают ошибки, что docker демон не стартует, можно посмотреть информацию командой что-то типа ``` sudo service docker start --debug ```.
Если проблема в cgroup, то пути решения следующие:
```bash
sudo groupadd docker
sudo usermod -aG docker $(whoami)
sudo service docker start
sudo dockerd --debug
sudo nano /etc/default/grub
# Добавить в переменную GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1"
sudo update-grub
sudo service docker stop
sudo cgroupfs-umount
sudo cgroupfs-mount
sudo service docker start
```
