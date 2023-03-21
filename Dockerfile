FROM adoptopenjdk/openjdk11:latest
MAINTAINER Jay 
COPY target/java-spring-mongodb-0.0.1-SNAPSHOT.jar /home/java-spring-mongodb-0.0.1-SNAPSHOT.jar
CMD ["java","-jar","/home/java-spring-mongodb-0.0.1-SNAPSHOT.jar"]