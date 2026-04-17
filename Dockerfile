# ====================Build Stage======================

# Base Image
FROM eclipse-temurin:21-jdk-jammy AS builder

# Set Working Directory
WORKDIR /app

# Copy Dependency-related Files
COPY pom.xml .
COPY mvnw .
COPY .mvn .mvn

# Copy Code
COPY src src

# Build Jar
RUN chmod +x mvnw && ./mvnw clean package -DskipTests

# =================== Runtime Stage=====================

# Base Image
FROM eclipse-temurin:21-jre-jammy

# Set Working Directory
WORKDIR /app

# Create Non-root User
RUN useradd -m appuser

# Copy Jar
COPY --from=builder /app/target/*.jar app.jar

# Change Ownership
RUN chown appuser:appuser app.jar

# Switch to Non-root User
USER appuser

# Expose Port
EXPOSE 8080

# Run & Serve Application
CMD ["java","-jar","app.jar"]


