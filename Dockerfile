FROM maven:3.6.0-jdk-8-slim AS build

WORKDIR /home/app

COPY . .

RUN mvn clean package

FROM openjdk:8u131-jdk-alpine

MAINTAINER Richard Chesterwood "contact@virtualpairprogrammers.com"

EXPOSE 8080

WORKDIR /usr/local/bin/

COPY --from=build /home/app/target/fleetman-0.0.1-SNAPSHOT.jar webapp.jar

CMD ["java", "-jar","webapp.jar"]
