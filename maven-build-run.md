## MAVEN сборка и запуск проекта из bash консоли:
```bash
# Компиляция ПО
cd ProjectDir
mvn compile
# Запуск ПО (нужно указать main класс в формате, который указан в команде)
mvn exec:java -D exec.mainClass='org.example.App'
```
