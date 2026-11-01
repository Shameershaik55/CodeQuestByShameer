FROM tomcat:10.1-jdk17-temurin

# Remove default Tomcat sample applications
RUN rm -rf /usr/local/tomcat/webapps/*

# Deploy CodeQuest as the root application (so it opens at / directly)
COPY CodeQuest.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]

