## Очистить данные о подключениях USB:
Чтобы очистить данные об подключениях выполнить:
``` bash
sudo dmesg -C
echo "" > /var/log/kern.log
```
Проверить можно:
``` bash
sudo dmesg | wc -l
cat /var/log/kern.log | wc -l
```
Вывод должен быть соответственно:
``` bash
0
1
```