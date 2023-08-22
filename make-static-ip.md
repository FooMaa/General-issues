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
