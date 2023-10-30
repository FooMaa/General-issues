##Почему Debian не видит Wi-Fi адаптер после установки:
Привести файл /etc/network/interfaces к виду:
``` bash
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
#iface lo inet loopback

# The primary network interface
#allow-hotplug wlo1
#iface wlo1 inet dhcp
#	wpa-ssid VAD
#	wpa-psk  23912391
```
Перезапустить демона networking:
``` bash
sudo service networking restart
```
Как вариант поустанавливать пакеты firmware*
