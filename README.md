# Программы:
* kdiff (для разрешения конфликтов на git)
* gitgui (удобно делать commit и push в git)
* doxigen (для документации)
* htop (диспетчер задач)
* ethtool (глубокая работа с сетевыми интерфейсами)
* ffmpeg (запись видео с экрана из bash)
* fsck (утилита в linux для проверки и восстановления файловой системы)
* vmware (утилита для создания и развертывания виртуальных машин)
# Помощь:
## Почему не подключается ПО к БД postgres в Astra Linux:
Файл /etc/parsec/mswitch.conf, параметр zero_if_notfound установить в yes.
В этом случае все пользователи БД, для которых не удалось получить мандатные атрибуты, получат нулевую метку.
## Git submodules:
```bash
[submodule "src/ltbs/audio/voice_core"]
path = src/libs/audio/voice_core
url = ssh://gitlab@10.1.2.97:2280/1710/voice_core.git
```
## Docker:
![изображение](https://github.com/FooMaa/-/assets/134139503/193ceb04-5ce3-4f98-bbb1-b42e54a81038)

**На Debian Linux ошибка Devices cgroup isn't mounted service docker stop:**
```bash
cgroupfs-umount
cgroupfs-mount
service docker start 
```
## Права доступа к некоторым файлам Linux:
* ``` id_rsa chmod 0600 ```
## QtCreator c маленькими шрифтами и кнопками на мониторах c высоким разрешением (или мелкопиксельные мониторы):
Для этого надо в .xprofile поставить переменную QT_SCALE_FACTOR и присвоить ей значение > 2, можно поиграть со значением, также можно создать себе скрипт:
```bash
#!/bin/bash
echo "Starting QtCreator"
export QT_SCALE_FACTOR=2.5
qtcreator
```
## Включить дистанционно ПК:
Поставить в BIOS в разделе Power переключатель Wake on Lan в состояние enable, прописать в Linux:
```bash
ethtool -s eth0 wol g
```
Чтоб со сторонней машины запустить:
```bash
wakeonlan 00:0e:2e:b9:cb:ad
```
Чтоб узнать MAC-адрес у сетевой карты, можно восользоваться:
```bash
ip a
```
## Если в Linux при автозапуске не работают X:
Тогда скрипт или ПО надо выполнять не как daemon или в cron, а создать файл, например, test.desktop по пути:
```bash
/etc/xdg/autostart
```
## Создать статический IP:
Прописать в /etc/network/interfaces:
```bash
auto eth0
iface eth0 interface static
address 196.120.134.12
netmask 255.255.255.0
gateway 196.120.0.1
dns-nameservers: 196.120.2.1
dns-nameservers: 196.120.2.15
```
## Создать docker контейнер на базе vmdk:
Установить пакеты:
```bash
sudo apt-get install docker.io
sudo apt-get install cgroupfs-mount
sudo apt-get install qemu-utils
```
Важно, чтоб установить контейнер, должна уже быть утсановлена вирутальная машина vmdk, для докера важно наличие файловой системы.
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
В процессе возникают ошибки, что docker демон не стартует можно посмотреть информацию командой что-то типа ```bash sudo service docker start --debug ```.
Если проблема в cgroup, то пути решения следующие:
```bash
sudo groupadd docker
sudo usermod -aG docker $(whoami)
sudo service docker start
sudo dockerd --debug
sudo nano /etc/default/grub
#Добавить в переменную GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1"
sudo update-grub
sudo service docker stop
sudo cgroupfs-umount
sudo cgroupfs-mount
sudo service docker start
```
