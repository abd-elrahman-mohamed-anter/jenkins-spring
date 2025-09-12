# Only one stage
FROM eclipse-temurin:17-jdk

WORKDIR /app

COPY . /app

RUN apt-get update && apt-get install -y maven && rm -rf /var/lib/apt/lists/*

RUN mvn package -DskipTests

EXPOSE 8080

CMD ["java", "-jar", "target/spring-petclinic-3.5.0-SNAPSHOT.jar"]
