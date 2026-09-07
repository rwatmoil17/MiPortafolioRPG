FROM tomcat:10-jdk21-openjdk
RUN rm -rf /usr/local/tomcat/webapps/ROOT
COPY dist/MiPortafolioPersonal.war /usr/local/tomcat/webapps/ROOT.war
