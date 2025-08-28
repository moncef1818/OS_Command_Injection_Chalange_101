# Multi-stage build - compile inside Docker
FROM maven:3.8-openjdk-11 AS build

WORKDIR /app
COPY pom.xml .
COPY src ./src

# Compile the application
RUN mvn clean package -DskipTests

# Runtime stage
FROM openjdk:11-jre-slim

# Install required packages
RUN apt-get update && apt-get install -y \
    iputils-ping \
    && rm -rf /var/lib/apt/lists/*

# Create secret using base64 (decode at runtime)
RUN echo "Tk9WQXtjMG1tNG5kXzFuajNjdDEwbl9tNHN0M3JfRzR0ZV8yMDI1fQ==" | base64 -d > /etc/secret

# Set working directory
WORKDIR /app

# Copy the JAR file from build stage
COPY --from=build /app/target/pingger-1.0.0.jar app.jar

# Expose port
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]