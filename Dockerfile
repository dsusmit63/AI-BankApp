# BUILD STAGE - BASE IMAGE
FROM eclipse-temurin:21-jdk-jammy AS builder

# WORKDIR
WORKDIR /app

# COPY ONLY NECESSARY FILES
COPY pom.xml .
COPY mvnw .
COPY .mvn .mvn

# COPY SOURCE CODE 
COPY src src

# BUILD THE JAR
RUN chmod +x mvnw && ./mvnw clean package -DskipTests

# RUNTIME STAGE
FROM eclipse-temurin:21-jre-jammy

# WORKDIR
WORKDIR /app

# COPY
COPY --from=builder /app/target/*.jar app.jar

# EXPOSE PORT
EXPOSE 8080

# RUN & SERVE APPLICATION
CMD ["java","-jar","app.jar"]


