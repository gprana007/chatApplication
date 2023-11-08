FROM eclipse-temurin:17-jdk-alpine
VOLUME /tmp
COPY target/*.jar chat_application.jar
ENTRYPOINT ["java","-jar","/chat_application.jar"]
EXPOSE 8080
