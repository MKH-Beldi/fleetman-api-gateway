FROM openjdk:8u131-jdk-alpine

MAINTAINER Richard Chesterwood "contact@virtualpairprogrammers.com"

EXPOSE 8080

WORKDIR /usr/local/bin/

COPY target/fleetman-api-gateway-0.0.1-SNAPSHOT.jar webapp.jar

CMD ["java", "-jar","webapp.jar"]
