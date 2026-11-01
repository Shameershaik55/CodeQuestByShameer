# ========================================================
# CodeQuest Cloud Deployment: Multi-Stage Docker Build
# Stage 1: Build the project using Maven & JDK 17
# Stage 2: Serve using Apache Tomcat 10.1
# ========================================================

# Stage 1: Maven Builder (compiles Java sources & packages WAR)
FROM maven:3.9.6-eclipse-temurin-17 AS builder
WORKDIR /app

# Copy Maven descriptor and source code
COPY pom.xml .
COPY src ./src

# Compile and package CodeQuest.war
RUN mvn clean package -DskipTests

# Stage 2: Apache Tomcat 10.1 Runtime
FROM tomcat:10.1-jdk17-temurin

# Clean out default Tomcat sample applications
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the WAR file compiled by Stage 1 directly into Tomcat webapps as ROOT.war
COPY --from=builder /app/target/CodeQuest.war /usr/local/tomcat/webapps/ROOT.war

# Default to 8080 if PORT is not set
ENV PORT=8080
EXPOSE 8080 10000

# Dynamically bind Tomcat's HTTP port to $PORT (assigned by Render / Cloud platforms)
CMD ["sh", "-c", "PORT=${PORT:-8080}; echo \"Binding Tomcat to port $PORT...\"; sed -i \"s/port=\\\"8080\\\"/port=\\\"$PORT\\\"/g\" /usr/local/tomcat/conf/server.xml && exec catalina.sh run"]
