# Используем образ с Java и Maven
FROM maven:3.8.5-openjdk-17 as build

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем pom.xml и скачиваем зависимости
COPY pom.xml .
RUN mvn dependency:go-offline

# Копируем остальные исходники
COPY src ./src

# Собираем проект
RUN mvn clean package

# Используем минимальный образ с Java для запуска
FROM openjdk:17-jdk-alpine

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем собранный .jar файл из предыдущего этапа
COPY --from=build /app/target/demo-0.0.1-SNAPSHOT.jar /app/demo.jar

# Указываем команду для запуска .jar файла
CMD ["java", "-jar", "/app/demo.jar"]
