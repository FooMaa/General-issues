## MAVEN установка с репозитория и обновление до последней версии:
Чтоб скачать maven для java из официального репозитория, надо в терминале ввести:
```bash
sudo apt install maven
```
Если версия java выше, чем версия java с которой maven из официального репозитория может работать, то переходим на официальный сайт maven 
```
https://maven.apache.org/download.cgi
```
Скачиваем Binary tar.gz archive; распаковываем:
```bash
tar -xzf apache-maven-3.8.6-bin.tar.gz
```
Затем нужно открыть в apache-maven-3.8.6-bin файл README.txt для проведения правильной установки. Это будет выглядеть примерно так:
```bash
sudo mv apache-maven-3.8.6 /opt/maven
echo "export M2_HOME=/opt/maven" >> ~/.bashrc
echo "export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64" >> ~/.bashrc
echo "export PATH=${M2_HOME}/bin:${PATH}" >> ~/.bashrc
source ~/.bashrc
export PATH=/opt/maven/bin:$PATH
```
И проверим версию maven:
```bash
mvn -v
```
Это возможно cработает только для текущего сеанса, а файл ~/.bashrc подтянется только при перезагрузке (я это не проверил). При желании можно поставить maven новой версии навсегда. Для этого найдем путь, где установлен maven с репозитория linux; из вывода команды нам нужен Maven Home путь:
```bash
mvn -v
```
В этом пути надо удалить все файлы:
```bash
cd /usr/share/maven
sudo rm -r *
```
Затем перенесем все папки и файлы из папки с maven новой версии:
```bash
sudo mv /opt/maven/* /usr/share/maven/
```
Затем выполняем:
```bash
nano ~/.bashrc
# И удаляем три последние строки, которые мы записали выше
```
Готово!
