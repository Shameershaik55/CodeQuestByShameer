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

# Expose standard Tomcat port
EXPOSE 8080

CMD ["catalina.sh", "run"]
