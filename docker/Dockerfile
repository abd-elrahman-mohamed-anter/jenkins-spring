# Build Stage


FROM eclipse-temurin:17-jdk-alpine AS build
WORKDIR /app

# Copy project files
COPY .. .

# Build with Maven Wrapper
RUN ./mvnw package -DskipTests


# Run Stage


FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Copy the built jar from the build stage
COPY --from=build /app/target/spring-petclinic-*.jar spring-petclinic.jar

# Expose application port
EXPOSE 8080

# Run the application
CMD ["java", "-jar", "spring-petclinic.jar"]

